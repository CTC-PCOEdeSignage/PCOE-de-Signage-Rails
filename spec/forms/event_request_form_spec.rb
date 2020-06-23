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

  context "with existing user" do
    let(:days_in_future) { 7 }
    let(:events_in_future) { 2 }
    let(:user) do
      create(:user, email: "rufus142@ohio.edu",
                    days_in_future: days_in_future,
                    events_in_future: events_in_future)
    end
    let!(:event) { create(:event, user: user) }
    let(:params) do
      {
        ohioid: "rufus142",
        room_id: room.id,
        start_at: start_at,
        duration: 60,
        purpose: Faker::Lorem.paragraph,
      }
    end
    let(:ctx) { { room: room } }
    let(:start_at) { 2.days.from_now.iso8601.to_s }

    before { user }

    it "should allow you to create another event if you have not reached your event limit" do
      expect(EventRequestForm
        .from_params(params)
        .with_context(ctx)).to be_valid
    end

    context "when events in future is 1" do
      let(:events_in_future) { 1 }

      it "should not allow you to create another event if you have reached your event limit" do
        subject = EventRequestForm.from_params(params).with_context(ctx)
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include("Time already reached event limit")
      end
    end

    context "when days in future is 1" do
      let(:days_in_future) { 1 }
      let(:start_at) { 3.days.from_now.iso8601.to_s }

      it "should not allow you to create an event too far into future" do
        subject = EventRequestForm.from_params(params).with_context(ctx)
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include(/Time too far in future./)
      end
    end
  end
end
