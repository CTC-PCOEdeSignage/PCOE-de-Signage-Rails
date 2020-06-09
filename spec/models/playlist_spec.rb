require "rails_helper"

RSpec.describe Playlist, type: :model do
  describe "validations" do
    subject { create(:playlist) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
