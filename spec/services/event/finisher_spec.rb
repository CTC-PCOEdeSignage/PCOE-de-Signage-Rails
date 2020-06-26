require "rails_helper"

RSpec.describe Event::Finisher, :type => :service do
  let!(:fully_finished_event) { create(:event, :finished, start_at: 5.days.ago) }
  let!(:approved_event_to_be_finished) { create(:event, :approved, start_at: 1.hour.ago, duration: 30) }
  let!(:declined_event_to_not_be_finished) { create(:event, :declined, start_at: 1.hour.ago, duration: 30) }
  let!(:approved_future_event) { create(:event, :approved, start_at: 5.days.from_now) }

  subject { described_class.new }
  let(:mail) { ActionMailer::Base.deliveries.last }

  before { subject.call }

  it "should send send email to finishing event only" do
    expect(mail.to).to include(approved_event_to_be_finished.user.email)
    expect(mail.subject).to include("How was your event?")
  end

  it "should mark events as finished" do
    [
      fully_finished_event,
      approved_event_to_be_finished,
      declined_event_to_not_be_finished,
      approved_future_event,
    ].each(&:reload)

    expect(fully_finished_event).to be_finished
    expect(approved_event_to_be_finished).to be_finished

    expect(declined_event_to_not_be_finished).to_not be_finished
    expect(approved_future_event).to_not be_finished
  end
end
