require "rails_helper"

RSpec.describe "Homepage", :type => :system do
  let!(:room) { create(:room) }

  before { visit "/" }

  it "enables me to view all rooms" do
    expect(page).to have_text("PCOE Project Rooms")
    expect(page).to have_text(room.name)
  end

  include_examples "accessible"
end
