require "rails_helper"

RSpec.describe EventRequestsController, type: :controller do
  let(:room) { create(:room) }
  let(:event) { create(:event) }

  describe "GET new" do
    it "should be ok" do
      get :new, params: { room_id: room.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
