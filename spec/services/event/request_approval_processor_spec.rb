require "rails_helper"

RSpec.describe Event::RequestApprovalProcessor, :type => :service do
  let(:user) { build(:user) }
  let(:room) { build(:room) }
  let(:event) { build(:event, :verified, room: room, user: user) }

  subject { Event::RequestApprovalProcessor.new(event) }

  context "when user is approved" do
    let(:user) { build(:user, :approved) }

    it "should approve the event" do
      subject.call

      event.reload
      expect(event).to be_approved
    end
  end

  context "when user is declined" do
    let(:user) { build(:user, :declined) }

    it "should decline the event" do
      subject.call

      event.reload
      expect(event).to be_declined
    end
  end

  context "when user is quarentined" do
    let(:user) { build(:user, :quarantined) }

    it "should keep the event verified" do
      subject.call

      expect(event).to be_verified
    end

    it "should keep the event verified" do
      fake_sender = double(:fake_sender, call: nil)
      expect(Event::RequestApprovalProcessor).to receive(:new).with(event).and_return(fake_sender)
      expect(fake_sender).to receive(:call)
      subject.call
    end
  end
end
