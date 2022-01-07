module Rooms
  class Availability
    def initialize(rooms:)
      @rooms = Array(rooms)
    end

    def availability
      @availability ||= @rooms.map(&:availability)
    end
  end
end
