class Room
  class Availability
    class NotAvailable < Struct.new(:day)
      def at?(_event_start_time, _event_end_time)
        false
      end
    end
  end
end
