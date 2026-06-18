class Lead < ApplicationRecord
  belongs_to :import, optional: true
  belongs_to :revenue_range, optional: true

  has_many :lead_assignments, dependent: :destroy
  has_many :assigned_users, through: :lead_assignments, source: :user
  has_many :call_sessions, dependent: :destroy
  has_many :status_histories, class_name: "LeadStatusHistory", dependent: :destroy
  has_one :active_assignment, -> { where(active: true) }, class_name: "LeadAssignment"
  has_one :current_sdr, through: :active_assignment, source: :user

  VALID_TRANSITIONS = {
    sem_contato: %i[tentativa remarcado agendado desqualificado excluido],
    tentativa:   %i[sem_contato remarcado agendado desqualificado excluido],
    remarcado:   %i[tentativa agendado desqualificado excluido sem_contato],
    agendado:    %i[desqualificado excluido remarcado tentativa],
    desqualificado: %i[sem_contato tentativa excluido],
    excluido:    %i[sem_contato]
  }.freeze

  enum :status, {
    sem_contato:    0,
    tentativa:      1,
    remarcado:      2,
    agendado:       3,
    desqualificado: 4,
    excluido:       5
  }, validate: true

  validates :company_name, presence: true, length: { maximum: 255 }
  validates :phone, length: { maximum: 30 }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :valid_status_transition, on: :update, if: :status_changed?

  scope :by_status, ->(s) { where(status: s) }
  scope :assigned_to, ->(user) { joins(:active_assignment).where(lead_assignments: { user_id: user.id }) }
  scope :pending, -> { where(status: :sem_contato) }
  scope :with_revenue_range, ->(rr) { where(revenue_range: rr) }

  def can_transition_to?(new_status)
    allowed = VALID_TRANSITIONS[status.to_sym] || []
    allowed.include?(new_status.to_sym)
  end

  def kanban_column
    status
  end

  private

  def valid_status_transition
    previous = status_before_last_save&.to_sym || status_was&.to_sym
    return unless previous
    return if can_transition_to?(status.to_sym)
    errors.add(:status, "transição inválida de #{previous} para #{status}")
  end
end
