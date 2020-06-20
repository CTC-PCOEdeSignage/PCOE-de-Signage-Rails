require "rails_helper"

RSpec.describe "Can Manage Users", :type => :system do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
    visit admin_root_path
  end

  it "can go to settings" do
    within("#header #tabs") do
      expect(page).to have_content("Settings")
      find("#settings").click
    end

    within("h2#page_title") do
      expect(page).to have_content("Settings")
    end
  end

  describe "updating settings" do
    it "should have existing settings" do
      visit admin_settings_path

      expect(page).to have_selector("form #editor")
      expect(page).to have_content("---")
      expect(page).to have_content("domain: ohio.edu")
    end

    it "should allow you to save" do
      expect(File).to receive(:write)
      expect(Config).to receive(:reload!)
      visit admin_settings_path

      click_button "Verify and Save"
      expect(page).to have_content("Settings Updated")
    end

    it "should catch YAML invalid errors" do
      visit admin_settings_path

      invalid_yaml_string = "---\nYAML: in:valid  : huh?"

      fill_settings_yaml(invalid_yaml_string)

      click_button "Verify and Save"
      expect(page).to have_content("Settings not updated")
      expect(page).to have_content("Invalid YAML syntax")
      expect(page).to have_content(invalid_yaml_string)
    end

    it "should catch invalid schema errors" do
      visit admin_settings_path

      base_settings = Settings.to_hash.stringify_keys
      base_settings.delete("domain")

      fill_settings_yaml(base_settings.to_yaml)

      click_button "Verify and Save"
      expect(page).to have_content("Settings not updated")
      expect(page).to have_content("domain is missing")
      expect(page).to have_content("web:")
      expect(page).to have_content("approved: After verifying")
      expect(page).to_not have_content("domain: ohio.edu".to_yaml)
    end

    def fill_settings_yaml(string)
      script =
        <<~SCRIPT
          var editor = ace.edit("editor")
          editor.setValue("#{escape_javascript(string)}")
        SCRIPT

      page.execute_script(script)
    end
  end
end
