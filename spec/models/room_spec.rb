require "rails_helper"

RSpec.describe Room, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:room) }
    it { is_expected.to validate_presence_of(:building) }

    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:screens) }
  end

  include_examples "duration optionable", :room

  describe "#availability" do
    let(:room) { build(:room) }

    it "returns an availability object" do
      expect(room.availability).to be_a(Room::Availability)
    end
  end
end
