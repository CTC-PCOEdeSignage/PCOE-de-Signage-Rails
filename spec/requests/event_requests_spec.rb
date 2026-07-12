require "rails_helper"

RSpec.describe "Event requests", type: :request do
  let(:room) { create(:room) }
  let(:monday) { Date.today.next_occurring(:monday) }
  let(:start_at) { (monday.middle_of_day + 1.hour).iso8601 }
  let(:valid_event_params) do
    {
      ohioid: "rb141412",
      start_at: start_at,
      duration: 60,
      purpose: Faker::Lorem.paragraph,
    }
  end

  around do |example|
    travel_to(monday.middle_of_day) { example.run }
  end

  before { ActionMailer::Base.deliveries.clear }

  describe "GET /rooms/:room_id/event_requests/new" do
    it "should be ok" do
      get new_room_event_request_path(room)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /rooms/:room_id/event_requests" do
    context "with valid params" do
      it "creates an event for the room" do
        expect {
          post room_event_requests_path(room), params: { event: valid_event_params }
        }.to change(Event, :count).by(1)

        event = Event.last
        expect(event.room).to eq(room)
        expect(event.duration).to eq(60)
        expect(event.start_at).to eq(monday.middle_of_day + 1.hour)
      end

      it "creates a user from the ohioid" do
        expect {
          post room_event_requests_path(room), params: { event: valid_event_params }
        }.to change(User, :count).by(1)

        expect(Event.last.user.email).to eq("rb141412@ohio.edu")
      end

      it "sends the verification email to the requester" do
        expect {
          post room_event_requests_path(room), params: { event: valid_event_params }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(ActionMailer::Base.deliveries.last.to).to eq(["rb141412@ohio.edu"])
      end

      it "redirects to the confirmation page" do
        post room_event_requests_path(room), params: { event: valid_event_params }

        expect(response).to redirect_to(room_event_request_confirmation_path(room, Event.last))
      end

      context "when a user with that email already exists" do
        let!(:user) { create(:user, email: "rb141412@ohio.edu") }

        it "reuses the existing user instead of creating another" do
          expect {
            post room_event_requests_path(room), params: { event: valid_event_params }
          }.to change(Event, :count).by(1).and change(User, :count).by(0)

          expect(Event.last.user).to eq(user)
        end
      end
    end

    context "with an invalid ohioid" do
      let(:params) { valid_event_params.merge(ohioid: "rc324204X") }

      it "creates no event and re-renders the form" do
        expect {
          post room_event_requests_path(room), params: { event: params }
        }.to_not change(Event, :count)

        expect(response).to have_http_status(:ok)
      end

      it "sends no email" do
        expect {
          post room_event_requests_path(room), params: { event: params }
        }.to_not change { ActionMailer::Base.deliveries.count }
      end
    end

    context "with a start_at in the past" do
      let(:params) { valid_event_params.merge(start_at: (monday.middle_of_day - 2.hours).iso8601) }

      it "creates no event and re-renders the form" do
        expect {
          post room_event_requests_path(room), params: { event: params }
        }.to_not change(Event, :count)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
