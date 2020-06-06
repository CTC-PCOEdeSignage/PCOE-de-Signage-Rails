require "rails_helper"

RSpec.describe Room::Availability::Available, :type => :service do
  let(:availability_start_time) { "8 am" }
  let(:availability_end_time) { "1 pm" }
  subject { Room::Availability::Available.new(:monday, availability_start_time, availability_end_time) }

  context "when starts too early" do
    let(:event_start_time) { Time.zone.parse("7 am") }
    let(:event_end_time) { Time.zone.parse("10 am") }

    it "should not be_available" do
      expect(subject.at?(event_start_time, event_end_time)).to eq(false)
    end
  end

  context "when within time boundaries" do
    let(:event_start_time) { Time.zone.parse("10 am") }
    let(:event_end_time) { Time.zone.parse("11 am") }

    it "should not be available" do
      expect(subject.at?(event_start_time, event_end_time)).to eq(true)
    end
  end
end
