require "rails_helper"

RSpec.describe ConfirmationsController, type: :controller do
  let(:room) { create(:room) }
  let(:event) { create(:event, room: room) }

  describe "GET event_verify" do
    it "should be ok" do
      get :verify, params: { room_id: room.id,
                             event_request_id: event.id,
                             verification_identifier: event.verification_identifier }

      expect(response).to redirect_to(room_event_request_confirmation_path(room, event))
    end

    context "when invalid verification_identifier" do
      it "should be raise error" do
        expect {
          get :verify, params: { room_id: room.id,
                                 event_request_id: event.id,
                                 verification_identifier: "invalid-identifier" }
        }.to raise_error RuntimeError, /Verification Identifier/

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
