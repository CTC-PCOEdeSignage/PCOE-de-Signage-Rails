class ConvertToDurationOptions
  def self.call(options)
    options.map { |option| [MinutesToWords.convert(option.minutes), option] }.to_h
  end
end
