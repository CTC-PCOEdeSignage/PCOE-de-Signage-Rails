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

  context "bulk import" do
    before { bulk_import_users }

    it "should allow bulk import" do
      expect(page).to have_content(/Successfully imported/)

      expect(User.count).to eq(3)
      expect(User.approved.count).to eq(1)
      expect(User.quarantined.count).to eq(1)
      expect(User.declined.count).to eq(1)
    end

    it "should allow bulk update" do
      # Set all (already imported) users to quarantined
      User.all.update_all(aasm_state: :quarantined)

      # Re-import
      bulk_import_users

      expect(User.count).to eq(3)
      expect(User.approved.count).to eq(1)
      expect(User.quarantined.count).to eq(1)
      expect(User.declined.count).to eq(1)
    end
  end

  private

  def bulk_import_users
    visit admin_users_path

    click_link "Import Users"

    within("form") do
      attach_file(Rails.root.join("spec", "support", "files", "example_users.csv"))
      click_button "Import"
    end
  end
end
