class WorkSession < ApplicationRecord
  belongs_to :user

  has_many :pauses, dependent: :destroy
  has_many :call_sessions, dependent: :nullify

  enum :status, {
    active: 0,
    paused: 1,
    completed: 2
  }, validate: true

  validates :started_at, presence: true

  scope :active_or_paused, -> { where(status: [ :active, :paused ]) }
  scope :completed, -> { where(status: :completed) }
  scope :for_date, ->(date) { where(started_at: date.beginning_of_day..date.end_of_day) }

  def elapsed_seconds
    return effective_duration_seconds if completed?
    base = started_at
    raw = Time.current - base
    raw - total_pause_duration_seconds - current_pause_seconds
  end

  def current_pause_seconds
    return 0 unless paused? && paused_at
    Time.current - paused_at
  end

  def pause!(pause_record)
    update!(status: :paused, paused_at: pause_record.started_at)
  end

  def resume!(ended_pause)
    duration = ended_pause.duration_seconds.to_i
    update!(
      status: :active,
      paused_at: nil,
      resumed_at: Time.current,
      total_pause_duration_seconds: total_pause_duration_seconds + duration
    )
  end

  def complete!
    now = Time.current
    total_elapsed = (now - started_at).round
    net = total_elapsed - total_pause_duration_seconds
    update!(
      status: :completed,
      ended_at: now,
      effective_duration_seconds: total_elapsed,
      net_work_duration_seconds: [ net, 0 ].max
    )
  end
end
