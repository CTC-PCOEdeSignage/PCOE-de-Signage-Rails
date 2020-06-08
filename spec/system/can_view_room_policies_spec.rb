require "rails_helper"

RSpec.describe "Room Policies", :type => :system do
  before { visit policies_rooms_path }

  include_examples "accessible"

  it "should contain 'Room Policies'" do
    expect(page).to have_content("Room Policies")
  end

  it "should have the policies" do
    expect(page).to have_css "ul li", minimum: 2
  end
end
