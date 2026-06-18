class LeadStatusHistory < ApplicationRecord
  belongs_to :lead
  belongs_to :changed_by, class_name: "User"

  validates :new_status, presence: true
  validates :changed_at, presence: true

  before_validation :set_changed_at, on: :create

  scope :recent, -> { order(changed_at: :desc) }

  def previous_status_label
    return "Nenhum" if previous_status.nil?
    Lead.statuses.key(previous_status).to_s.humanize
  end

  def new_status_label
    Lead.statuses.key(new_status).to_s.humanize
  end

  private

  def set_changed_at
    self.changed_at ||= Time.current
  end
end
