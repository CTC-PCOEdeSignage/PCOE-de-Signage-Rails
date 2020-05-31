class Event
  class Limits
    # Limit reservations X days in the future
    # Site-wide configurable default (e.g. 14 days)
    # Per-user configurable (overrides default)

    # Limit X number of events in the future
    # Site-wide configurable default (e.g. 1 event)
    # Per-user configurable (overrides default)

    SITE_WIDE_DAYS_IN_FUTURE = SystemConfiguration.get(:limits, :days_in_future).to_i
    SITE_WIDE_EVENTS_IN_FUTURE = SystemConfiguration.get(:limits, :events_in_future).to_i

    def initialize(room: nil, user: nil)
      @room = room
      @user = user
    end

    def days_in_future
      (per_user_days_in_future || SITE_WIDE_DAYS_IN_FUTURE).days
    end

    def events_in_future
      per_user_events_in_future || SITE_WIDE_EVENTS_IN_FUTURE
    end

    private

    def per_user_days_in_future
      nil #TODO
    end

    def per_user_events_in_future
      nil #TODO
    end
  end
end
