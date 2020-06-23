require "rails_helper"

RSpec.describe "Can Manage Users", :type => :system do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    visit admin_root_path
  end

  it "can go to rooms" do
    within("#header #tabs") do
      expect(page).to have_content("Rooms")
      find("#rooms").click
    end

    within("h2#page_title") do
      expect(page).to have_content("Rooms")
    end
  end

  context "with room" do
    let!(:room) { create(:room) }
    before { visit admin_rooms_path }

    it "can set duration_options for room" do
      within_dom_id(room) do
        click_link("Edit")
      end

      expect(page).to have_content "Duration Options"

      fill_in "Duration Options", with: "15, 30, 90"
      click_button "Update Room"

      expect(page).to have_content "15, 30, 90"
      room.reload
      expect(room.duration_options).to eq [15, 30, 90]
    end
  end
end
