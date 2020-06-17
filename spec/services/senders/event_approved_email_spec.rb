require "rails_helper"

RSpec.describe Senders::EventApprovedEmail, :type => :service do
  let(:event) { build_stubbed(:event) }
  let(:deliverable) { double(:deliverable, deliver_later: true) }
  subject { described_class.new(event) }

  context "when persisted" do
    before { allow(event).to receive(:persisted?).and_return(true) }

    it "should send email" do
      expect(EventMailer).to receive(:approve).with(event).and_return(deliverable)
      expect(deliverable).to receive(:deliver_later)

      subject.call
    end
  end

  context "when not persisted" do
    before { allow(event).to receive(:persisted?).and_return(false) }

    it "should not send email" do
      expect(EventMailer).to_not receive(:approve)

      subject.call
    end
  end
end
