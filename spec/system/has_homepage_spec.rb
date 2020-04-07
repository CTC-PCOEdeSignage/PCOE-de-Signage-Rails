require "rails_helper"

RSpec.describe "Homepage", :type => :system do
  let!(:screen) { create(:screen) }

  it "enables me to view all screens" do
    visit "/"

    expect(page).to have_text("PCOE - All Screens")
    expect(page).to have_text(screen.name)

    expect(page).to be_accessible
  end
end
