class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable

  enum :role, { sdr: 0, admin: 1 }, validate: true

  has_many :lead_assignments, dependent: :destroy
  has_many :leads, through: :lead_assignments
  has_many :call_sessions, dependent: :destroy
  has_many :pauses, dependent: :destroy
  has_many :work_sessions, dependent: :destroy
  has_many :audit_logs, dependent: :nullify
  has_many :imports, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }
  validates :session_timeout_minutes, numericality: { greater_than: 0, less_than_or_equal_to: 1440 }

  scope :active_sdrs, -> { where(active: true, role: :sdr).order(:name) }
  scope :active_admins, -> { where(active: true, role: :admin).order(:name) }
  scope :sdrs, -> { where(role: :sdr) }
  scope :admins, -> { where(role: :admin) }

  def current_work_session
    work_sessions.where(status: [ WorkSession.statuses[:active], WorkSession.statuses[:paused] ])
                 .order(started_at: :desc)
                 .first
  end

  def active_pause
    pauses.where(ended_at: nil).order(started_at: :desc).first
  end

  def paused?
    current_work_session&.paused?
  end

  def working?
    current_work_session&.active?
  end

  def pending_leads_count
    lead_assignments.where(active: true)
                    .joins(:lead)
                    .where(leads: { status: Lead.statuses[:sem_contato] })
                    .count
  end

  def to_s
    name
  end
end
