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

      expect(page).to have_content("User: Approved")
      expect(page).to have_current_path(admin_users_path)

      user.reload
      expect(user).to be_approved
    end

    it "can declined user" do
      within_dom_id(user) do
        expect(page).to have_content(user.email)
        click_link("Decline")
      end

      expect(page).to have_content("User: Declined")
      expect(page).to have_current_path(admin_users_path)

      user.reload
      expect(user).to be_declined
    end
  end

  describe "bulk import" do
    describe "without status" do
      it "should allow bulk by not specifying status" do
        bulk_import_users(EXAMPLE_PATH)

        expect(User.count).to eq(3)
        expect(User.approved.count).to eq(3)
      end

      it "should allow bulk and setting to Decline All" do
        bulk_import_users(EXAMPLE_PATH, "Decline All")

        expect(User.count).to eq(3)
        expect(User.declined.count).to eq(3)
      end

      it "should allow bulk and setting to Quarantine All" do
        bulk_import_users(EXAMPLE_PATH, "Quarantine All")

        expect(User.count).to eq(3)
        expect(User.quarantined.count).to eq(3)
      end
    end

    describe "including status" do
      before { bulk_import_users(EXAMPLE_WITH_STATUS_PATH) }

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
        bulk_import_users(EXAMPLE_WITH_STATUS_PATH)

        expect(User.count).to eq(3)
        expect(User.approved.count).to eq(1)
        expect(User.quarantined.count).to eq(1)
        expect(User.declined.count).to eq(1)
      end
    end
  end

  private

  EXAMPLE_PATH = Rails.root.join("spec", "support", "files", "example_users.csv")
  EXAMPLE_WITH_STATUS_PATH = Rails.root.join("spec", "support", "files", "example_users_with_status.csv")

  def bulk_import_users(path, select_import_option = nil)
    visit admin_users_path

    click_link "Import Users"

    within("form") do
      attach_file(path)
      choose(select_import_option) if select_import_option

      click_button "Import"
    end
  end
end
