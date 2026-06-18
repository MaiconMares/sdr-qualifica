class CallSession < ApplicationRecord
  belongs_to :lead
  belongs_to :user
  belongs_to :work_session, optional: true

  enum :status, {
    in_progress: 0,
    completed:   1,
    abandoned:   2
  }, validate: true

  validates :started_at, presence: true

  scope :completed, -> { where(status: :completed) }
  scope :finished, -> { where(status: :completed) }
  scope :for_date, ->(date) { where(started_at: date.beginning_of_day..date.end_of_day) }
  scope :for_sdr, ->(user) { where(user: user) }

  def end!(at: Time.current)
    secs = (at - started_at).round
    update!(ended_at: at, duration_seconds: secs, status: :completed)
  end

  def duration_label
    return "Em andamento" unless duration_seconds
    secs = duration_seconds
    format("%02d:%02d:%02d", secs / 3600, (secs % 3600) / 60, secs % 60)
  end

  def started_at_label
    started_at&.strftime("%H:%M:%S")
  end

  def ended_at_label
    ended_at&.strftime("%H:%M:%S")
  end
end
