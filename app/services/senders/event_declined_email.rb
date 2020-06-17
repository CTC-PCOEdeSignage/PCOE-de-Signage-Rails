module Senders
  class EventDeclinedEmail
    def initialize(event)
      @event = event
    end

    def call
      return unless @event.persisted?

      EventMailer.decline(@event).deliver_later
    end
  end
end
