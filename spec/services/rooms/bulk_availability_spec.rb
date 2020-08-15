require "rails_helper"

RSpec.describe Rooms::BulkAvailability, type: :service do
  let(:rooms) { create_list(:room, 3) }
  let(:rule) { IceCube::Rule.weekly }
  let(:params) do
    {
      "recurring_rule" => rule.to_hash.to_json,
      "rooms" => rooms.map(&:id),
      "event_purpose" => "Do something!",
      "event_email" => "test@ohio.edu",
    }
  end

  subject { Rooms::BulkAvailability.new(params: params) }

  around do |example|
    travel_to Date.parse("1/1/2020") do
      example.run
    end
  end

  context "#availability" do
    it "should not raise error" do
      expect { subject.availability }.to_not raise_error
    end
  end

  context "#persist!" do
    it "should not raise error" do
      expect { subject.persist! }.to_not raise_error
    end

    it "should create persisted events" do
      subject.persist!
      expect(Event.count).to eq(42)
    end
  end
end
