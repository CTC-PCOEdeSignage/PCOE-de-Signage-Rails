class Room
  class Availability
    DAYS_OF_WEEK = Date::DAYNAMES.map(&:downcase)

    def initialize(room:)
      @room = room
    end

    def availability(on:)
      @availability_cache ||= {}

      @availability_cache[on] ||= begin
          on = on.to_date
          events_on_date = room.events.impacting.on_date(on).to_a

          base_availability(on)
            .map do |availability|
            next(availability) if availability.not_available?
            next(availability) unless available_during_events?(availability, events_on_date)

            NotAvailable.new(availability.time)
          end
        end
    end

    def available_between?(start_at, end_at)
      availability(on: start_at).any? do |availability|
        availability.available? &&
          within_time?(availability.time, start_at: start_at, end_at: end_at)
      end
    end

    def availability_at(time)
      availability(on: time).find { |a| a.time == time }
    end

    def available_now?
      now = Time.current.floor_to(30.minutes)

      available_between?(now, now + 30.minutes)
    end

    def next_available
      date = Date.today

      loop do
        if available = availability(on: date)
          .select(&:future?)
          .select(&:available?)
          .first
          return available.time
        end

        date += 1.day
      end
    end

    private

    attr_reader :room

    def base_availability(date)
      day_of_the_week = date.to_formatted_s(:day).downcase
      start_time, end_time = global[day_of_the_week].start, global[day_of_the_week].end

      start_time = date.time_parse_in_context(start_time) if start_time
      end_time = date.time_parse_in_context(end_time) if end_time

      date
        .beginning_of_day
        .ranged_by(24.hours, step: 30.minutes)
        .map do |time|
        if (start_time <= time) && (time < end_time)
          Available.new(time)
        else
          Closed.new(time)
        end
      end
    end

    def available_during_events?(availability, events)
      events.any? { |event| within_time?(availability.time, start_at: event.start_at, end_at: event.end_at) }
    end

    def within_time?(time, start_at:, end_at:)
      start_at <= time && time < end_at
    end

    def global
      @global ||= Settings.availability
    end
  end
end
