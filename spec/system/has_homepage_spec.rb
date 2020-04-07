require "rails_helper"

RSpec.describe "Homepage", :type => :system do
  it "enables me to view all screens" do
    visit "/"

    expect(page).to have_text("PCOE - All Screens")
    expect(page).to be_accessible
  end
end
