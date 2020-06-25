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

      event.reload
      expect(event).to be_verified
    end

    it "should safely verify twice" do
      get :verify, params: { room_id: room.id,
                             event_request_id: event.id,
                             verification_identifier: event.verification_identifier }

      expect {
        get :verify, params: { room_id: room.id,
                               event_request_id: event.id,
                               verification_identifier: event.verification_identifier }
      }.to_not raise_error
    end

    context "when has AdminUser who is set to receive event approvals" do
      let!(:admin_user) { create(:admin_user, email: "grand-puba@ohio.edu", receive_event_approvals: true) }

      it "should send an email to each admin user" do
        get :verify, params: { room_id: room.id,
                               event_request_id: event.id,
                               verification_identifier: event.verification_identifier }

        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to include("grand-puba@ohio.edu")
      end
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
