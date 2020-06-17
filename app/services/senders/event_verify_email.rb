module Senders
  class EventVerifyEmail
    def initialize(event)
      @event = event
    end

    def call
      return unless @event.persisted?

      EventMailer.validate_user(@event).deliver_later
    end
  end
end
