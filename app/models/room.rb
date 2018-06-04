class Room < ApplicationRecord
  validates_presence_of :building, :room, :libcal_identifier
  validates_numericality_of :libcal_identifier

  has_many :room_screens, -> { order(position: :asc) }
  has_many :screens, through: :room_screens, dependent: :destroy
  validates_uniqueness_of :name
  validates_uniqueness_of :libcal_identifier

  default_scope { order(building: :asc, room: :asc) }

  def libcal_availability
    @libcal_availability ||= LibcalRoomAvailability.new(self, LibcalOauth.default_token)
  end
end
