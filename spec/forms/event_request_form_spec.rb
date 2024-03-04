require "rails_helper"

RSpec.describe EventRequestForm, type: :form do
  let(:room) { create(:room) }
  let(:time) { Date.today.next_occurring(:monday).middle_of_day }
  let(:valid_params) do
    {
      ohioid: " rb141412  ", #extra space intentional to simulate extra space
      room_id: room.id,
      start_at: time.iso8601.to_s,
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

  context "with Don's ohioid" do
    before { valid_params[:ohioid] = "weekley" }
    subject { EventRequestForm.from_params(valid_params).with_context(context) }

    it "should be valid" do
      expect(subject).to be_valid
    end
  end

  context "with Didi's ohioid" do
    before { valid_params[:ohioid] = "chilcotd" }
    subject { EventRequestForm.from_params(valid_params).with_context(context) }

    it "should be valid" do
      expect(subject).to be_valid
    end
  end

  context "with Ricky's student ohioid" do
    before { valid_params[:ohioid] = "rc324204" }
    subject { EventRequestForm.from_params(valid_params).with_context(context) }

    it "should be valid" do
      expect(subject).to be_valid
    end
  end

  context "with bad student ohioid" do
    before { valid_params[:ohioid] = "rc324204X" }
    subject { EventRequestForm.from_params(valid_params).with_context(context) }

    it "should not be valid" do
      expect(subject).not_to be_valid
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
      expect(subject.errors.full_messages).to include(/Time must be in the future/)
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
    let(:days_in_future) { 8 }
    let(:events_in_future) { 2 }
    let!(:user) do
      create(:user, email: "rb141412@ohio.edu",
                    days_in_future: days_in_future,
                    events_in_future: events_in_future)
    end
    let!(:event) { create(:event, user: user) }
    let(:start_at) { Date.today.next_occurring(:monday).middle_of_day.iso8601.to_s }
    let(:params) do
      {
        ohioid: "rb141412",
        room_id: room.id,
        start_at: start_at,
        duration: 60,
        purpose: Faker::Lorem.paragraph,
      }
    end
    let(:ctx) { { room: room } }

    it "should allow you to create another event if you have not reached your event limit" do
      form = EventRequestForm.from_params(params).with_context(ctx)
      expect(form).to be_valid
    end

    context "when events in future is 1" do
      let(:events_in_future) { 1 }
      subject { EventRequestForm.from_params(params).with_context(ctx) }

      it "should not allow you to create another event if you have reached your event limit" do
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include(/Ohioid already reached event limit/)
      end
    end

    context "when days in future is 1" do
      let(:days_in_future) { 1 }
      let(:start_at) { (Date.today.next_occurring(:monday).middle_of_day + 7.days).iso8601.to_s }
      subject { EventRequestForm.from_params(params).with_context(ctx) }

      it "should not allow you to create an event too far into future" do
        expect(subject).to_not be_valid
        expect(subject.errors.full_messages).to include(/Time too far in future./)
      end
    end
  end

  describe "room availability" do
    context "with successive event" do
      let(:monday) { Date.today.next_occurring(:monday) }
      let(:time) { monday.middle_of_day + 1.hour }

      before { create(:event, start_at: monday.middle_of_day, duration: 60, room: room) }

      it "should be valid if not overlapping" do
        travel_to monday.middle_of_day do
          expect(subject).to be_valid
          expect(subject.errors.full_messages).to_not include(/Time not available/)
        end
      end
    end

    context "with overlapping event" do
      let(:monday) { Date.today.next_occurring(:monday) }
      let(:time) { monday.middle_of_day }

      before { create(:event, start_at: monday.middle_of_day, duration: 60, room: room) }

      it "should be invalid if overlapping" do
        travel_to monday.middle_of_day do
          expect(subject).to_not be_valid
          expect(subject.errors.full_messages).to include(/Time not available/)
        end
      end
    end

    context "on a sunday" do
      let(:sunday) { Date.today.next_occurring(:sunday) }
      let(:time) { sunday.middle_of_day }

      it "should be invalid when closed" do
        travel_to sunday.middle_of_day do
          expect(subject).to_not be_valid
          expect(subject.errors.full_messages).to include(/Time not available/)
        end
      end
    end
  end
end
