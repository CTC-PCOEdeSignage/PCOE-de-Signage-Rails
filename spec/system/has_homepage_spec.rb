require "rails_helper"

RSpec.describe "Homepage", :type => :system do
  let!(:screen) { create(:screen) }

  before { visit "/" }

  it "enables me to view all screens" do
    expect(page).to have_text("PCOE - All Screens")
    expect(page).to have_text(screen.name)

    expect(page).to be_accessible
  end
end
