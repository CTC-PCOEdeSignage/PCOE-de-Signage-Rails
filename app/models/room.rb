class Room < ApplicationRecord
  include HasDurationOptions

  validates_presence_of :name, :building, :room

  has_many :events
  has_many :future_events, -> { future }, class_name: "Event"
  has_many :room_screens, -> { order(position: :asc) }, inverse_of: :room
  has_many :screens, through: :room_screens, dependent: :destroy
  validates_uniqueness_of :name

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def availability
    @availability ||= Availability.new(room: self)
  end
end
