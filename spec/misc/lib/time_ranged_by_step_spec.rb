require "rails_helper"

RSpec.describe "Time#ranged_by" do
  let(:duration) { 60.minutes }
  subject { Time.current.ranged_by(duration) }

  it "should be an array of times" do
    expect(subject).to be_an Array
    expect(subject).to all(be_a Time)
  end

  it "should default to 1 minute steps" do
    freeze_time do
      expect(subject.size).to eq(60)
      expect(subject.first).to eq(Time.current)
      expect(subject.last).to eq(Time.current + 1.hour - 1.minute)
    end
  end

  describe "with step" do
    let(:step) { 15.minutes }
    subject { Time.current.ranged_by(duration, step: step) }

    it "should allow passing in arbitrary steps" do
      freeze_time do
        expect(subject.size).to eq(4)
        expect(subject.first).to eq(Time.current)
        expect(subject.last).to eq(Time.current + 45.minutes)
      end
    end
  end
end
