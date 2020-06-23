class Event
  class Limits
    # Limit reservations X days in the future
    # Site-wide configurable default (e.g. 14 days)
    # Per-user configurable (overrides default)

    # Limit X number of events in the future
    # Site-wide configurable default (e.g. 1 event)
    # Per-user configurable (overrides default)

    SITE_WIDE_DAYS_IN_FUTURE = Settings.limits.days_in_future
    SITE_WIDE_EVENTS_IN_FUTURE = Settings.limits.events_in_future

    def initialize(user: nil)
      @user = user
    end

    def days_in_future
      per_user_days_in_future || SITE_WIDE_DAYS_IN_FUTURE
    end

    def events_in_future
      per_user_events_in_future || SITE_WIDE_EVENTS_IN_FUTURE
    end

    private

    def per_user_days_in_future
      @user&.days_in_future
    end

    def per_user_events_in_future
      @user&.events_in_future
    end
  end
end
