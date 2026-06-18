class Import < ApplicationRecord
  belongs_to :user

  has_one_attached :file

  enum :status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }, validate: true

  validates :filename, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def progress
    progress_percentage
  end

  def progress_percentage
    return 0 if total_rows.nil? || total_rows.zero?
    ((processed_rows.to_f / total_rows) * 100).round(1)
  end

  def duration_seconds
    return nil unless started_at && finished_at
    (finished_at - started_at).round
  end

  def in_progress?
    pending? || processing?
  end
end
