class LeadAssignment < ApplicationRecord
  belongs_to :lead
  belongs_to :user
  belongs_to :assigned_by, class_name: "User", optional: true

  validates :assigned_at, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :ordered, -> { order(:position) }

  before_validation :set_assigned_at, on: :create

  def deactivate!
    update!(active: false)
  end

  private

  def set_assigned_at
    self.assigned_at ||= Time.current
  end
end
