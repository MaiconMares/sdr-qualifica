class Pause < ApplicationRecord
  belongs_to :user
  belongs_to :work_session

  REASONS = {
    reuniao_lideranca: 0,
    reuniao_cliente:   1,
    banheiro:          2,
    comer:             3,
    outro:             4
  }.freeze

  REASON_LABELS = {
    reuniao_lideranca: "Reunião com liderança",
    reuniao_cliente:   "Reunião com cliente",
    banheiro:          "Ir ao banheiro",
    comer:             "Comer",
    outro:             "Outro"
  }.freeze

  enum :reason, REASONS, validate: true

  validates :started_at, presence: true
  validates :description, presence: true, if: -> { outro? }
  validate :description_required_for_outro

  scope :active, -> { where(ended_at: nil) }
  scope :completed, -> { where.not(ended_at: nil) }
  scope :for_date, ->(date) { where(started_at: date.beginning_of_day..date.end_of_day) }

  def end!(at: Time.current)
    secs = (at - started_at).round
    update!(ended_at: at, duration_seconds: secs)
  end

  def active?
    ended_at.nil?
  end

  def duration_label
    return "Em andamento" if active?
    secs = duration_seconds.to_i
    format("%02d:%02d:%02d", secs / 3600, (secs % 3600) / 60, secs % 60)
  end

  def reason_label
    REASON_LABELS[reason.to_sym]
  end

  private

  def description_required_for_outro
    return unless reason.to_s == "outro" && description.blank?
    errors.add(:description, "é obrigatória para pausas do tipo Outro")
  end
end
