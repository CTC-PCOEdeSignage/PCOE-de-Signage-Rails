require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { is_expected.to_not validate_presence_of(:first_name) }
    it { is_expected.to_not validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:aasm_state) }

    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to have_many(:events) }
  end

  it "should automatically downcase email on save" do
    email = "ASDFlfkj@ohio.edu"
    user = build(:user, email: email)
    user.save!

    expect(user.email).to_not eq(email)
    expect(user.email).to eq(email.downcase)
  end

  describe "state machine" do
    subject { build_stubbed(:user) }

    it "when quarantined" do
      expect(subject.aasm_state).to eq("quarantined")

      expect(subject).to allow_event(:whitelist)
      expect(subject).to allow_event(:blacklist)
    end

    it "when whitelisted" do
      subject.aasm_state = "whitelisted"

      expect(subject).to allow_event(:quarantine)
      expect(subject).to allow_event(:blacklist)
    end

    it "when blacklisted" do
      subject.aasm_state = "blacklisted"

      expect(subject).to allow_event(:quarantine)
      expect(subject).to allow_event(:whitelist)
    end
  end
end
