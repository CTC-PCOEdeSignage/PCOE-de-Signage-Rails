class Room
  class Availability
    class Available
      def initialize(day, available_start_time, available_end_time)
        @day = day
        @available_start_time = Time.zone.parse(available_start_time)
        @available_end_time = Time.zone.parse(available_end_time)
      end

      def at?(event_start_time, event_end_time)
        available_start_time < event_start_time && event_end_time < available_end_time
      end

      private

      attr_reader :available_start_time, :available_end_time
    end
  end
end
