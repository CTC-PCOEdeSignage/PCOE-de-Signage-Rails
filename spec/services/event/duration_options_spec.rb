require "rails_helper"

RSpec.describe Event::DurationOptions, :type => :service do
  let(:room) { nil }
  let(:user) { nil }

  subject { Event::DurationOptions.new(room: room, user: user) }

  context "default" do
    it "allows you to get default" do
      expect(subject.default).to eq(30)
    end

    it "allows you to get options" do
      expect(subject.options).to include("30 mins" => 30)
      expect(subject.options).to include("1 hr" => 60)
      expect(subject.options).to include("2 hrs" => 120)
    end
  end
end
