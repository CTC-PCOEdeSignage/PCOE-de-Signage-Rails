require "rails_helper"

RSpec.describe "Can Manage Events", :type => :system do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    visit admin_root_path
  end

  it "can go to events" do
    within("#header #tabs") do
      expect(page).to have_content("Events")
      find("#events").click
    end

    within("h2#page_title") do
      expect(page).to have_content("Events")
    end
  end

  context "with event" do
    let!(:event) { create(:event, :verified) }
    before { visit admin_events_path }

    it "can approve event" do
      within_dom_id(event) do
        expect(page).to have_content(event.user.email)
        click_link("Approve")
      end

      expect(page).to have_content("Event: Approved")
      expect(page).to have_current_path(admin_events_path)
      event.reload
      expect(event).to be_approved
    end

    it "can declined event" do
      within_dom_id(event) do
        expect(page).to have_content(event.user.email)
        click_link("Decline")
      end

      expect(page).to have_content("Event: Declined")
      expect(page).to have_current_path(admin_events_path)
      event.reload
      expect(event).to be_declined
    end
  end
end
