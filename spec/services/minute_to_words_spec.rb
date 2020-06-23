require "rails_helper"

RSpec.describe MinutesToWords do
  subject { MinutesToWords.convert(time) }

  context "when 30 minutes" do
    let(:time) { 30.minutes }

    it { expect(subject).to eq("30 minutes") }
  end

  context "when 60 minutes" do
    let(:time) { 60.minutes }

    it { expect(subject).to eq("1 hour") }
  end

  context "when 90 minutes" do
    let(:time) { 90.minutes }

    it { expect(subject).to eq("90 minutes") }
  end

  context "when 120 minutes" do
    let(:time) { 120.minutes }

    it { expect(subject).to eq("2 hours") }
  end

  context "when 115 minutes" do
    let(:time) { 115.minutes }

    it { expect(subject).to eq("115 minutes") }
  end
end
