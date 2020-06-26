class ActiveSupport::TimeWithZone
  def ranged_by(duration, step: 1.minute)
    (self.to_i...(self + duration).to_i)
      .step(step)
      .map { |time| Time.zone.at(time) }
  end
end
