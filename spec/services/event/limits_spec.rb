require "rails_helper"

RSpec.describe Event::Limits, :type => :service do
  let(:room) { nil }
  let(:user) { nil }

  subject { Event::Limits.new(room: room, user: user) }

  context "default" do
    it "allows you to get future_events limit" do
      expect(subject.events_in_future).to eq(1)
    end

    it "allows you to get days in future limit" do
      expect(subject.days_in_future).to eq(14.days)
    end
  end
end
