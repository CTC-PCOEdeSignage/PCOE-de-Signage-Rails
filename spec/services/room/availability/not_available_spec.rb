require "rails_helper"

RSpec.describe Room::Availability::NotAvailable, :type => :service do
  let(:end_time) { "8 am" }
  let(:start_time) { "1 pm" }

  let(:event_start_time) { Time.parse("7 am") }
  let(:event_end_time) { Time.parse("10 am") }

  subject { Room::Availability::NotAvailable.new(:day) }

  it "should not be available" do
    expect(subject.at?(event_start_time, event_end_time)).to eq(false)
  end
end
