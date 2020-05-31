require "rails_helper"

RSpec.describe Room::Availability, :type => :service do
  let(:room) { nil }

  subject { Room::Availability.new(room: room) }

  it "allows you to get availability for a day that's not availabile" do
    expect(subject.availability(on: :sunday)).to be_a(Room::Availability::NotAvailable)
    expect(subject.availability(on: :saturday)).to be_a(Room::Availability::NotAvailable)
  end

  it "allows you to get availability for a day that's availabile" do
    expect(subject.availability(on: :monday)).to be_a(Room::Availability::Available)
    expect(subject.availability(on: :tuesday)).to be_a(Room::Availability::Available)
    expect(subject.availability(on: :wednesday)).to be_a(Room::Availability::Available)
    expect(subject.availability(on: :thursday)).to be_a(Room::Availability::Available)
    expect(subject.availability(on: :friday)).to be_a(Room::Availability::Available)
  end
end
