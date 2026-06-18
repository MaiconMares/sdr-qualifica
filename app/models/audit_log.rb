class AuditLog < ApplicationRecord
  belongs_to :user, optional: true

  ACTIONS = {
    login:              0,
    logout:             1,
    pause_started:      2,
    pause_ended:        3,
    call_started:       4,
    call_ended:         5,
    status_changed:     6,
    lead_imported:      7,
    lead_assigned:      8,
    lead_redistributed: 9,
    work_session_start: 10,
    work_session_end:   11,
    user_created:       12,
    user_updated:       13,
    user_deactivated:   14
  }.freeze

  ACTION_LABELS = {
    login:              "Login",
    logout:             "Logout",
    pause_started:      "Pausa iniciada",
    pause_ended:        "Pausa encerrada",
    call_started:       "Ligação iniciada",
    call_ended:         "Ligação encerrada",
    status_changed:     "Status alterado",
    lead_imported:      "Lead importado",
    lead_assigned:      "Lead atribuído",
    lead_redistributed: "Lead redistribuído",
    work_session_start: "Sessão de trabalho iniciada",
    work_session_end:   "Sessão de trabalho encerrada",
    user_created:       "Usuário criado",
    user_updated:       "Usuário atualizado",
    user_deactivated:   "Usuário desativado"
  }.freeze

  enum :action, ACTIONS, validate: true

  validates :action, presence: true
  validates :occurred_at, presence: true

  before_validation :set_occurred_at, on: :create

  scope :recent, -> { order(occurred_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
  scope :for_date, ->(date) { where(occurred_at: date.beginning_of_day..date.end_of_day) }
  scope :for_action, ->(a) { where(action: a) }

  def action_label
    ACTION_LABELS[action.to_sym]
  end

  private

  def set_occurred_at
    self.occurred_at ||= Time.current
  end
end
