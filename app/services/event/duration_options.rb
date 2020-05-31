class Event
  class DurationOptions
    # Site-wide configurable list of options (e.g. 30 minutes, 1 hour, 2 hours, 3 hours, etc.)
    # Site-wide configurable default (e.g. 1 hour)
    # Per-user configurable (overrides default)

    SITE_WIDE_OPTIONS = SystemConfiguration.get(:duration, :options).map { |option| [option["text"].to_s, option["minutes"].to_i] }.to_h
    SITE_WIDE_DEFAULT = SystemConfiguration.get(:duration, :default).to_i

    def initialize(room: nil, user: nil)
      @room = room
      @user = user
    end

    def options
      per_user_config || SITE_WIDE_OPTIONS
    end

    def default
      return SITE_WIDE_DEFAULT if options == SITE_WIDE_OPTIONS

      options.values.first
    end

    private

    def per_user_config
      nil #TODO
    end
  end
end
