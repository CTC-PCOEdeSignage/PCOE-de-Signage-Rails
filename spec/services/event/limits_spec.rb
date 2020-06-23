require "rails_helper"

RSpec.describe Event::Limits, :type => :service do
  let(:user) { build(:user) }

  subject { Event::Limits.new(user: user) }

  describe "site-wide default" do
    it "allows you to get future_events limit" do
      expect(subject.events_in_future).to eq(1)
    end

    it "allows you to get days in future limit" do
      expect(subject.days_in_future).to eq(14)
    end
  end

  context "when user overrides" do
    let(:user) { build(:user, events_in_future: 5, days_in_future: 21) }

    it "allows you to get future_events limit" do
      expect(subject.events_in_future).to eq(5)
    end

    it "allows you to get days in future limit" do
      expect(subject.days_in_future).to eq(21)
    end
  end
end
