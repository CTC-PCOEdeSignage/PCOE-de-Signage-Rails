class Event
  class DurationOptions
    # Site-wide configurable list of options (e.g. 30 minutes, 1 hour, 2 hours, 3 hours, etc.)
    # Site-wide configurable default (e.g. 1 hour)
    # Per-room configurable (overrides default)
    # Per-user configurable (overrides default)
    SITE_WIDE_OPTIONS = ConvertToDurationOptions.call(Settings.duration.options)
    SITE_WIDE_DEFAULT = Settings.duration.default

    def initialize(room:, user:)
      @room = room
      @user = user
    end

    def options
      per_user_config
        .merge(per_room_config)
        .merge(SITE_WIDE_OPTIONS)
    end

    def default
      per_user_config&.values&.first ||
      per_room_config&.values&.first ||
      SITE_WIDE_DEFAULT
    end

    private

    def per_user_config
      return {} unless @user

      @user.duration_options_hash
    end

    def per_room_config
      return {} unless @room

      @room.duration_options_hash
    end
  end
end
