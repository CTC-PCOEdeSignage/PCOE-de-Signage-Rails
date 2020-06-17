module Senders
  class EventApprovedEmail
    def initialize(event)
      @event = event
    end

    def call
      return unless @event.persisted?

      EventMailer.approve(@event).deliver_later
    end
  end
end
