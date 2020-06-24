module ParseInTimeContext
  refine Date do
    def time_parse_in_context(str)
      Time.parse("#{self} #{str}")
    end
  end
end
