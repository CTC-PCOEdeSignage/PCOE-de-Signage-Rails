class Room
  class Availability
    class Available < Struct.new(:day, :available_start_time, :available_end_time)
      def at?(event_start_time, event_end_time)
        return true
        # TODO
        available_start_time < event_start_time && event_end_time < available_end_time
      end
    end
  end
end
