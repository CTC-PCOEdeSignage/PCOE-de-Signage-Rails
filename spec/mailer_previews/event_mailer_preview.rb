class EventMailerPreview < ActionMailer::Preview
  def validate_user
    EventMailer.validate_user(event)
  end

  def approve
    EventMailer.approve(event)
  end

  def decline
    EventMailer.decline(event)
  end

  def finish
    EventMailer.finish(event)
  end

  def request_approval
    EventMailer.request_approval(event)
  end

  private

  def event
    Event.first || FactoryBot.create(:event)
  end
end
