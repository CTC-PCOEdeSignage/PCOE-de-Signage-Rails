class CreateEventRequest < Rectify::Command
  def initialize(form)
    @form = form
  end

  def call
    return broadcast(:invalid) if form.invalid?

    transaction do
      find_or_create_user
      create_event
      send_user_validate_email
    end

    broadcast(:ok, event)
  end

  private

  attr_reader :form, :user, :event

  def find_or_create_user
    @user = User.find_or_create_by(email: form.full_email)
  end

  def create_event
    attrs =
      form
        .attributes
        .slice(:start_at, :duration, :purpose)
        .merge({ user: user, room: form.room })

    @event = Event.create!(attrs)
  end

  def send_user_validate_email
    Senders::EventVerifyEmail.new(event).call
  end
end
