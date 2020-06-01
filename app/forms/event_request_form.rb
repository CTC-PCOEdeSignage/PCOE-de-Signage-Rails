class DateTimeWithZone < Virtus::Attribute
  def coerce(value)
    return unless value.presence

    Time.zone.parse(value)
  end
end

class EventRequestForm < Rectify::Form
  mimic :event

  attribute :ohioid, String
  attribute :start_at, DateTimeWithZone
  attribute :duration, Integer
  attribute :purpose, String
  attribute :user, User

  validates :ohioid, :start_at, :duration, presence: true
  validate :check_room
  validate :check_ohioid
  validate :check_valid_date
  validates_length_of :purpose, within: 3..500

  def user
    @user ||= User.find_by(email: full_email)
  end

  def full_email
    return unless ohioid

    [ohioid.downcase, "@", SystemConfiguration.get(:domain)].join
  end

  def duration_select_options
    duration_options.options
  end

  def duration_select_default
    duration_options.default
  end

  def date
    next_available_time.strftime("%Y-%m-%d")
  end

  def time
    next_available_time.strftime("%H:%M")
  end

  private

  def next_available_time
    # TODO
    1.hour.from_now.beginning_of_hour
  end

  def duration_options
    @duration_options ||= Event::DurationOptions.new(room: context.room, user: user)
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

    errors.add(:start_at, "must be in the future") if start_at < Time.current
  end
end
