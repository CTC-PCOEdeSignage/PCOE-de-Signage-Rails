class Event
  class DurationOptions
    # Site-wide configurable list of options (e.g. 30 minutes, 1 hour, 2 hours, 3 hours, etc.)
    # Site-wide configurable default (e.g. 1 hour)
    # Per-user configurable (overrides default)

    SITE_WIDE_OPTIONS = Settings.duration.options.map(&:to_hash).map { |option| [option[:text], option[:minutes]] }.to_h
    SITE_WIDE_DEFAULT = Settings.duration.default

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
