require "rails_helper"

RSpec.describe "Homepage", :type => :system do
  # before do
  #   driven_by(:rack_test)
  # end

  it "enables me to create widgets" do
    visit "/"

    expect(page).to have_text("PCOE - All Screens")
    expect(page).to be_accessible
  end
end
