class RevenueRange < ApplicationRecord
  has_many :leads, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position) }

  def to_s
    name
  end
end
