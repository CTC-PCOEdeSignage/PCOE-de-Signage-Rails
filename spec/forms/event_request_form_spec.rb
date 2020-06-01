require "rails_helper"

RSpec.describe EventRequestForm, type: :form do
  let(:room) { create(:room) }
  let(:base_time) { 1.day.from_now.beginning_of_hour }
  let(:valid_params) do
    {
      ohioid: "rufus142",
      room_id: room.id,
      start_at: base_time.iso8601.to_s,
      duration: 60,
      purpose: Faker::Lorem.paragraph,
    }
  end

  let(:context) { { room: room } }
  subject { EventRequestForm.from_params(valid_params).with_context(context) }

  it "should be valid" do
    subject.valid?
    expect(subject.errors).to be_empty
  end

  context "without ohioid" do
    let(:params) { valid_params.without(:ohioid) }
    subject { EventRequestForm.from_params(params).with_context(context) }

    it "should not be valid" do
      expect(subject).to_not be_valid
      expect(subject.errors).to_not be_empty
      expect(subject.errors).to include(:ohioid)
    end
  end

  context "without valid start_at" do
    let(:params) { valid_params.without(:start_at) }
    subject { EventRequestForm.from_params(params).with_context(context) }

    it "should not be valid" do
      expect(subject).to_not be_valid
      expect(subject.errors).to_not be_empty
      expect(subject.errors).to include(:start_at)
    end
  end

  context "without future date and time" do
    let(:params) { valid_params.merge(start_at: DateTime.parse("1/1/1995 8:00 am").iso8601.to_s) }
    subject { EventRequestForm.from_params(params).with_context(context) }

    it "should not be valid" do
      expect(subject).to_not be_valid
      expect(subject.errors).to_not be_empty
      expect(subject.errors.messages).to include(start_at: ["must be in the future"])
    end
  end

  context "without duration" do
    let(:params) { valid_params.without(:duration) }
    subject { EventRequestForm.from_params(params).with_context(context) }

    it "should not be valid" do
      expect(subject).to_not be_valid
      expect(subject.errors).to_not be_empty
      expect(subject.errors).to include(:duration)
    end
  end

  context "without purpose" do
    let(:params) { valid_params.without(:purpose) }
    subject { EventRequestForm.from_params(params).with_context(context) }

    it "should not be valid" do
      expect(subject).to_not be_valid
      expect(subject.errors).to_not be_empty
      expect(subject.errors).to include(:purpose)
    end
  end
end
