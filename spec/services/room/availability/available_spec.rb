require "rails_helper"

RSpec.describe Room::Availability::Available, :type => :service do
  subject { described_class.new(time) }

  context "30 minutes ago" do
    let(:time) { 30.minutes.ago }

    it { expect(subject.future?).to eq(false) }
    it { expect(subject.available?).to eq(true) }
    it { expect(subject.closed?).to eq(false) }
  end

  context "30 minutes from now" do
    let(:time) { 30.minutes.from_now }

    it { expect(subject.future?).to eq(true) }
    it { expect(subject.available?).to eq(true) }
    it { expect(subject.closed?).to eq(false) }
  end
end
