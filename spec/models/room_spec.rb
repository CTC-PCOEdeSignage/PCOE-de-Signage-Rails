require "rails_helper"

RSpec.describe Room, type: :model do
  subject { build(:room) }

  it "should have valid factory" do
    expect(subject).to be_valid
  end
end
