class Room
  class Availability
    class NotAvailable < Base
      attr_writer :blocking_event
    end
  end
end
