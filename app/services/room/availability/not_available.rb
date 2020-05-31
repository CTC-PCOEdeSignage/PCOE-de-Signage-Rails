class Room
  class Availability
    class NotAvailable < Struct.new(:day)
      def at?(event_start_time, event_end_time)
        false
      end
    end
  end
end
