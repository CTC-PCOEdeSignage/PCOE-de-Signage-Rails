class Screen < ApplicationRecord
  ROTATION_OPTION = [90, 270]
  LAYOUT_OPTION = %w(single dual)

  validates_presence_of :name, :rotation, :layout
  validates :rotation, inclusion: { in: ROTATION_OPTION, message: "%{value} is not a valid rotation" }
  validates :layout, inclusion: { in: LAYOUT_OPTION, message: "%{value} is not a valid layout" }

  has_many :room_screens, inverse_of: :screen
  has_many :rooms, through: :room_screens, dependent: :destroy
  belongs_to :playlist, optional: true

  accepts_nested_attributes_for :room_screens, allow_destroy: true
  scope :alpha_sorted, -> { order(name: :asc) }

  def self.layouts
    LAYOUT_OPTION
  end

  def self.rotations
    ROTATION_OPTION
  end
end
