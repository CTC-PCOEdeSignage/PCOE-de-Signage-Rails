require "rails_helper"

RSpec.describe "Event Status", :type => :system do
  let(:room) { create(:room) }
  let(:event) { create(:event, room: room, aasm_state: aasm_state) }
  before { visit room_event_request_confirmation_path(event.room, event) }

  context "when requested" do
    let(:aasm_state) { :requested }

    it { expect(page).to have_content("Event request received.") }
    include_examples "event details", :event
    include_examples "accessible"
  end

  context "when verified" do
    let(:aasm_state) { :verified }

    it { expect(page).to have_content("Thank you for verifying your email address.") }
    include_examples "event details", :event
    include_examples "accessible"
  end

  context "when approved" do
    let(:aasm_state) { :approved }

    it { expect(page).to have_content("After verifying your email address, your project room request has been approved.") }
    include_examples "event details", :event
    include_examples "accessible"
  end

  context "when declined" do
    let(:aasm_state) { :declined }

    it { expect(page).to have_content("We’re sorry, but your project room request has been declined.") }
    include_examples "event details", :event
    include_examples "accessible"
  end

  context "when finished" do
    let(:aasm_state) { :finished }

    include_examples "event details", :event
    include_examples "accessible"
  end
end
