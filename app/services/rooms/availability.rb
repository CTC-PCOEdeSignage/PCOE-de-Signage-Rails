module Rooms
  class Availability
    def initialize(rooms:)
      @rooms = Array(rooms)
    end

    def availability
      @availability ||= @rooms.map { |room| Room::Availability.new(room: room) }
    end
  end
end
