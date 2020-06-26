require "rails_helper"

RSpec.describe Admin::EventsController, type: :controller do
  let(:admin) { create(:admin_user) }

  let(:event) { create(:event, :verified) }

  before { sign_in admin }

  describe "GET run" do
    it "should be able to approve" do
      get :run, params: { id: event.id, aasm_event: :approve }
      expect(response).to redirect_to(admin_events_path)
      event.reload
      expect(event).to be_approved
    end

    it "should be able to decline" do
      get :run, params: { id: event.id, aasm_event: :decline }
      expect(response).to redirect_to(admin_events_path)
      event.reload
      expect(event).to be_declined
    end
  end

  describe "POST run" do
    it "should be able to approve" do
      post :run, params: { id: event.id, aasm_event: :approve }
      expect(response).to redirect_to(admin_events_path)
      event.reload
      expect(event).to be_approved
    end

    it "should be able to decline" do
      post :run, params: { id: event.id, aasm_event: :decline }
      expect(response).to redirect_to(admin_events_path)
      event.reload
      expect(event).to be_declined
    end
  end
end
