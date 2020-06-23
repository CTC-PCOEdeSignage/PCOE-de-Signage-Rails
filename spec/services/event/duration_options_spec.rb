require "rails_helper"

RSpec.describe Event::DurationOptions, :type => :service do
  let(:room) { build(:room, duration_options: [15]) }
  let(:user) { build(:user, duration_options: [90]) }

  subject { Event::DurationOptions.new(room: room, user: user) }

  it "allows you to get default" do
    expect(subject.default).to eq(90)
  end

  it "allows you to get all options" do
    expect(subject.options).to include("15 minutes" => 15)
    expect(subject.options).to include("30 minutes" => 30)
    expect(subject.options).to include("90 minutes" => 90)
    expect(subject.options).to include("1 hour" => 60)
    expect(subject.options).to include("2 hours" => 120)
  end

  context "without user" do
    let(:user) { nil }

    it { expect { subject.options }.to_not raise_error }
  end

  context "without room" do
    let(:room) { nil }

    it { expect { subject.options }.to_not raise_error }
  end
end
