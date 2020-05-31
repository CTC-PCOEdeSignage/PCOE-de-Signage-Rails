class EventRequestForm < Rectify::Form
  mimic :event

  attribute :email, String
  attribute :room_id, Integer
  attribute :start_at, DateTime
  attribute :duration, Integer
  attribute :purpose, String
  attribute :user, User

  validates :email, :start_at, :duration, presence: true
  validate :check_room
  validate :check_full_email
  validates_length_of :purpose, within: 3..500

  def user
    @user ||= User.find_by(email: full_email)
  end

  def room
    @room ||= Room.find(room_id)
  end

  def full_email
    return unless email

    [email.downcase, "@", SystemConfiguration.get(:domain)].join
  end

  def duration_select_options
    duration_options.options
  end

  def duration_select_default
    duration_options.default
  end

  private

  def duration_options
    @duration_options ||= Event::DurationOptions.new(room: room, user: user)
  end

  def check_room
    return if room

    errors.add(:room_id, "not a room")
  end

  def check_full_email
    return if full_email && full_email.match(/\A.*@#{SystemConfiguration.get(:domain)}\z/)

    errors.add(:room_id, "not a room")
  end
end
