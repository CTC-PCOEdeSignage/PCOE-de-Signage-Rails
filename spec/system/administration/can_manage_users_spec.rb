require "rails_helper"

RSpec.describe "Can Manage Users", :type => :system do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    visit admin_root_path
  end

  it "can go to users" do
    within("#header #tabs") do
      expect(page).to have_content("Users")
      find("#users").click
    end

    within("h2#page_title") do
      expect(page).to have_content("Users")
    end
  end

  context "with user" do
    let!(:user) { create(:user, :quarantined) }
    before { visit admin_users_path }

    it "can approve user" do
      within_dom_id(user) do
        expect(page).to have_content(user.email)
        click_link("Approve")
      end

      user.reload
      expect(user).to be_approved
    end

    it "can declined user" do
      within_dom_id(user) do
        expect(page).to have_content(user.email)
        click_link("Decline")
      end

      user.reload
      expect(user).to be_declined
    end
  end
end
