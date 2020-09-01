class DateTimeWithZone < Virtus::Attribute
  def coerce(value)
    return unless value.presence

    t = Time.zone.parse(value)
    t.floor_to(30.minutes)
  end
end

class EventRequestForm < Rectify::Form
  mimic :event

  attribute :ohioid, String
  attribute :date, Date # this is a placeholder attribute
  attribute :time, Time # this is a placeholder attribute
  attribute :start_at, DateTimeWithZone
  attribute :duration, Integer
  attribute :purpose, String
  attribute :user, User

  validates :ohioid, :start_at, :duration, presence: true
  validate :check_room
  validate :check_ohioid
  validate :check_valid_date
  validate :check_room_availability
  validate :check_limit_days_in_future
  validate :check_limit_events_in_future
  validates_length_of :purpose, within: Event::PURPOSE_LENGTH_CONSTRAINT

  def user
    return nil unless full_email

    @user ||= User.find_or_create_by(email: full_email)
  end

  def ohioid
    @ohioid&.downcase&.strip
  end

  def full_email
    return unless ohioid

    [ohioid, "@", Settings.domain].join
  end

  def duration_select_options
    duration_options.options
  end

  def duration_select_default
    duration_options.default
  end

  def date
    @date ||= room_availability.next_available
  end

  def date_min
    room_availability.next_available
  end

  def date_max
    (limits.days_in_future).days.from_now
  end

  def time
    @time ||= room_availability.next_available
  end

  private

  def room_availability
    @room_availability ||= Room::Availability.new(room: context.room)
  end

  def duration_options
    @duration_options = Event::DurationOptions.new(room: context.room, user: user)
  end

  def limits
    @limits ||= Event::Limits.new(user: user)
  end

  def limit_events_in_future
    limits.events_in_future
  end

  def check_room
    return if context.room

    errors.add(:room_id, "not a room")
  end

  def check_ohioid
    return if ohioid && ohioid.length == 8

    errors.add(:ohioid, "must be valid OHIO ID")
  end

  def check_valid_date
    return unless start_at.presence

    if start_at < Time.current
      add_errors_to_time_fields("must be in the future")
    end
  end

  def check_room_availability
    return unless start_at && duration

    unless room_availability.available_between?(start_at, start_at + duration.minutes)
      add_errors_to_time_fields("not available at this time")
    end
  end

  def check_limit_days_in_future
    return unless start_at

    if start_at > limits.days_in_future.days.from_now
      add_errors_to_time_fields("too far in future. Pick date less than #{limits.days_in_future} in future")
    end
  end

  def check_limit_events_in_future
    if users_future_events.size == limit_events_in_future
      errors.add(:ohioid, "already reached event limit for this user. Wait until your other events have completed and then book again.")
    end
  end

  def users_future_events
    user&.future_events || []
  end

  def add_errors_to_time_fields(message)
    errors.add(:start_at, message)
    errors.add(:date, message)
    errors.add(:time, message)
  end
end
