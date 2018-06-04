class Screen < ApplicationRecord
  validates_presence_of :name, :rotation, :layout
  validates :rotation, inclusion: { in: [90, 270], message: "%{value} is not a valid rotation" }
  validates :layout, inclusion: { in: %w(single dual), message: "%{value} is not a valid layout" }

  has_many :room_screens
  has_many :rooms, through: :room_screens, dependent: :destroy
  belongs_to :playlist, optional: true

  accepts_nested_attributes_for :room_screens, allow_destroy: true

  def self.layouts
    %w(single dual)
  end

  def self.rotations
    [90, 270]
  end
end
