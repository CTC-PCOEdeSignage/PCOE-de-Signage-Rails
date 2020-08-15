class RecurringSchedule
  def initialize(params, now = Time.current)
    @params = params
    @now = now
  end

  def occurrences
    schedule = IceCube::Schedule.new(now)
    schedule.add_recurrence_rule(rule)

    schedule.all_occurrences.map do |occurrence|
      start_at = occurrence.to_date.time_parse_in_context(start_time)
      end_at = start_at + duration.to_i

      (start_at..end_at)
    end
  end

  private

  attr_reader :params, :now

  def duration
    @duration ||= params["duration"].presence || 1.hour
  end

  def end_date
    @end_date ||= begin
        end_date_string = params["end_date"].presence || 3.months.from_now.to_s
        Date.parse(end_date_string)
      end
  end

  def start_time
    @start_time ||= params["start_time"].presence || "12 am"
  end

  def rule
    rule = RecurringSelect.dirty_hash_to_rule(params["recurring_rule"])
    return(rule.until(end_date)) if rule.present?

    raise "Invalid Rule #{params["recurring_rule"]}"
  end
end
