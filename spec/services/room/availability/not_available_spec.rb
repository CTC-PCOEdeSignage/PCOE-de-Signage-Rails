require "rails_helper"

RSpec.describe Room::Availability::NotAvailable, :type => :service do
  subject { described_class.new(time) }
  let(:time) { Time.now }

  context "30 minutes ago" do
    let(:time) { 30.minutes.ago }

    it { expect(subject.future?).to eq(false) }
    it { expect(subject.available?).to eq(false) }
    it { expect(subject.closed?).to eq(false) }
  end

  context "30 minutes from now" do
    let(:time) { 30.minutes.from_now }

    it { expect(subject.future?).to eq(true) }
    it { expect(subject.available?).to eq(false) }
    it { expect(subject.closed?).to eq(false) }
  end

  context "with blocking event" do
    let(:event) { double(:blocking_event) }

    it "can have a blocking event" do
      subject.blocking_event = event
      expect(subject.blocking_event).to eq(event)
      expect(subject.blocking_event?).to eq(true)
    end

    it "doesn't require blocking event" do
      expect(subject.blocking_event).to eq(nil)
      expect(subject.blocking_event?).to eq(false)
    end
  end
end
