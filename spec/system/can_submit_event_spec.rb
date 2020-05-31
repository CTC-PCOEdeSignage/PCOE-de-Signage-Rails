require "rails_helper"

RSpec.describe "Request Event", :type => :system do
  let(:room) { create(:room) }

  before { visit new_room_event_request_path(room) }

  it "room scheduler is accessible" do
    expect(page).to be_accessible
  end

  it "should have room name" do
    expect(page).to have_text("Schedule #{room.name}")
  end

  xit "should allow you to request event" do
    fill_in "Email", with: "rufus"
    fill_in "Purpose", with: "Bobcat cage escape training"
    click_on "Request"
  end
end
