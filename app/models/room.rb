class Room < ApplicationRecord
  validates_presence_of :building, :room, :libcal_identifier
  validates_numericality_of :libcal_identifier

  has_many :room_screens, -> { order(position: :asc) }
  has_many :screens, through: :room_screens
end
