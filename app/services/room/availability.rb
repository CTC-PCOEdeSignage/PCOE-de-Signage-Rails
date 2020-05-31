class Room
  class Availability
    DAYS_OF_WEEK = Date::DAYNAMES.map(&:downcase)

    def initialize(room: nil)
      @room = room
    end

    def availability(on:)
      on = on.to_s.downcase
      raise "Unknown day" unless DAYS_OF_WEEK.include?(on)
      start_time, end_time = available_on(on)["start"], available_on(on)["end"]

      return NotAvailable.new(on) if start_time == end_time

      Available.new(on, start_time, end_time)
    end

    private

    attr_reader :room

    def available_on(day_of_the_week)
      day_of_the_week_availability = room[day_of_the_week]
      day_of_the_week_availability ||= global[day_of_the_week]
    end

    def room
      {} # TODO
    end

    def global
      SystemConfiguration.get(:availability)
    end
  end
end
