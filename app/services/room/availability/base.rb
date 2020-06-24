class Room
  class Availability
    class Base
      def initialize(time)
        @time = time
      end

      def future?
        time > Time.current
      end

      def not_available?
        !available?
      end

      def available?
        false
      end

      def closed?
        false
      end

      attr_reader :time
    end
  end
end
