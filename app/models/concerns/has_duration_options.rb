module HasDurationOptions
  extend ActiveSupport::Concern
  DURATION_OPTION_SEPARATOR = ","

  included do
    serialize :duration_options, Array
  end

  def duration_options
    self.attributes["duration_options"].map(&:to_i)
  end

  def duration_options_hash
    ConvertToDurationOptions.call(self.duration_options)
  end

  def duration_options_string
    self.duration_options.join(DURATION_OPTION_SEPARATOR)
  end

  def duration_options_string=(new_value)
    self.duration_options = new_value.split(DURATION_OPTION_SEPARATOR).map(&:strip)
  end
end
