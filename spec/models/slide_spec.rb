require "rails_helper"

RSpec.describe Slide, type: :model do
  describe "validations" do
    subject { create(:slide) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:style) }

    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_inclusion_of(:style).in_array(Slide::STYLE_OPTIONS) }
  end
end
