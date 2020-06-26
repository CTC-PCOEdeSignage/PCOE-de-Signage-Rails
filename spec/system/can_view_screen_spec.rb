require "rails_helper"

RSpec.describe "Can View Slideshow", :type => :system do
  let(:room_screen) { create(:room_screen) }
  let(:room) { room_screen.room }
  let!(:screen) { room_screen.screen }
  let!(:playlist) { create(:playlist) }
  let!(:slide) { Slide.default_slide.tap(&:save!) }

  before do
    room.update name: "Primary Room"
    screen.update layout: "single"
    playlist.playlist_slides.create(position: 1, slide: slide)
    screen.update playlist: playlist
    visit screen_path(screen)
  end

  it "should contain room name and single slide" do
    expect(page).to have_content("Primary Room")
    expect(page).to have_content("Available Now")
    expect(page).to have_content("Slide Not Found")
  end

  context "with all schedule slide" do
    let!(:all_schedule_slide) { create(:slide, :all_schedule_slide) }
    let!(:other_room) { create(:room, name: "Other Room") }

    before do
      playlist.playlist_slides.destroy_all
      playlist.playlist_slides.create(position: 1, slide: all_schedule_slide)
      visit screen_path(screen)
    end

    it "should render" do
      expect(page).to have_content("Primary Room")
      expect(page).to have_content("Other Room")
    end
  end
end
