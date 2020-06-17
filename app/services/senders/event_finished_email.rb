module Senders
  class EventFinishedEmail
    def initialize(event)
      @event = event
    end

    def call
      return unless @event.persisted?

      EventMailer.finish(@event).deliver_later
    end
  end
end
