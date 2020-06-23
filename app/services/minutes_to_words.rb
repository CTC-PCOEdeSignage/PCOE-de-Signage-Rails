module FloatWholeNumber
  refine Float do
    def is_whole?
      self % 1 == 0
    end
  end
end

using FloatWholeNumber

class MinutesToWords
  def self.convert(duration)
    seconds = duration.to_i
    minutes = seconds / 60.0
    hours = minutes / 60.0

    return "#{minutes.to_i} minutes" unless hours.is_whole?

    hours = hours.to_i
    if hours == 1
      "#{hours} hour"
    else
      "#{hours} hours"
    end
  end
end
