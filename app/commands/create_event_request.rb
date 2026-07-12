class CreateEventRequest
  def self.call(form) = new(form).call

  def initialize(form)
    @form = form
  end

  def call
    return if form.invalid?

    ActiveRecord::Base.transaction do
      find_or_create_user
      create_event
      send_user_validate_email
    end

    event
  end

  private

  attr_reader :form, :user, :event

  def find_or_create_user
    @user = User.find_or_create_by(email: form.full_email)
  end

  def create_event
    @event = Event.create!(
      start_at: form.start_at,
      duration: form.duration,
      purpose: form.purpose,
      user: user,
      room: form.room,
    )
  end

  def send_user_validate_email
    Senders::EventVerifyEmail.new(event).call
  end
end
