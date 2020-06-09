require "rails_helper"

RSpec.describe "Policies", :type => :system do
  let(:room_screen) { create(:room_screen) }
  let(:room) { room_screen.room }
  let!(:screen) { room_screen.screen }
  let!(:playlist) { create(:playlist) }
  let!(:slide) { Slide.default_slide.tap(&:save!) }

  before do
    screen.update layout: "single"
    playlist.playlist_slides.create(position: 1, slide: slide)
    screen.update playlist: playlist
    visit screen_path(screen)
  end

  it "should contain room name and single slide" do
    expect(page).to have_content(screen.rooms.first.name)
    expect(page).to have_content("Available Now")
    expect(page).to have_content("Slide Not Found")
  end
end
