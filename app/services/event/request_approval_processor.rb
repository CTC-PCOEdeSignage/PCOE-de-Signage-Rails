class Event
  class RequestApprovalProcessor
    def initialize(event)
      @event = event
    end

    def call
      if @event.user.approved?
        @event.approve
      elsif @event.user.declined?
        @event.decline
      else
        Senders::EventRequestApprovalEmail.new(@event).call
      end

      true
    end
  end
end
