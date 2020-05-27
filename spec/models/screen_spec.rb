require "rails_helper"

RSpec.describe Screen, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:rotation) }
    it { is_expected.to validate_presence_of(:layout) }

    it { is_expected.to validate_inclusion_of(:rotation).in_array(Screen::ROTATION_OPTION).with_message(/is not a valid rotation/) }
    it { is_expected.to validate_inclusion_of(:layout).in_array(Screen::LAYOUT_OPTION).with_message(/is not a valid layout/) }

    it { is_expected.to belong_to(:playlist).optional }
    it { is_expected.to have_many(:rooms) }
  end
end
