module Senders
  class EventRequestApprovalEmail
    def initialize(event)
      @event = event
    end

    def call
      return unless @event.persisted?

      EventMailer.request_approval(@event).deliver_later
    end
  end
end
