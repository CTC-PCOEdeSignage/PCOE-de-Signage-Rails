require "rails_helper"

RSpec.describe "Request Event", :type => :system do
  let(:room) { create(:room) }

  before { visit new_room_event_request_path(room) }

  describe "happy path" do
    include_examples "accessible"

    it "should have room name" do
      expect(page).to have_text("Event Request")
    end

    it "should allow you to request event and create user end event" do
      submit_event_request

      user, event = User.first, Event.first

      expect(User.count).to eq(1)
      expect(Event.count).to eq(1)
      expect(user.email).to eq("rb141412@ohio.edu")
      expect(event.room.name).to eq(room.name)
      expect(event.start_at).to eq(Date.today.next_occurring(:monday).middle_of_day)
      expect(event.duration).to eq(120)
      expect(event.purpose).to eq("Bobcat cage escape training")
    end

    it "should allow you to change room after selecting another" do
      another_room = create(:room, name: "Another Room")

      refresh

      submit_event_request(room: another_room)

      user, event = User.first, Event.first

      expect(User.count).to eq(1)
      expect(Event.count).to eq(1)
      expect(user.email).to eq("rb141412@ohio.edu")
      expect(event.room.name).to eq("Another Room")
      expect(event.start_at).to eq(Date.today.next_occurring(:monday).middle_of_day)
      expect(event.duration).to eq(120)
      expect(event.purpose).to eq("Bobcat cage escape training")
    end

    it "should redirect to a confirmation page" do
      submit_event_request

      should_be_on_confirmation_page
    end

    it "should email a verification email" do
      expect { submit_event_request }.to change { ActionMailer::Base.deliveries.size }.by(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include("rb141412@ohio.edu")
      expect(mail.body.encoded).to include("Verify")
    end
  end

  describe "when error" do
    context "with too long ohio id" do
      before { submit_event_request(ohioid: "too_long_ohio_id") }

      it "should show error message" do
        expect(page).to have_content("must be valid OHIO ID")
      end

      it "should be fixable and re-submittable" do
        submit_event_request
        should_be_on_confirmation_page
      end

      include_examples "accessible"
    end

    context "with short purpose" do
      before { submit_event_request(purpose: "abcd") }

      it "should show error message" do
        expect(page).to have_content("Purpose\nabcd\nis too short (minimum is 5 characters)")
      end

      it "should be fixable and re-submittable" do
        submit_event_request
        should_be_on_confirmation_page
      end

      include_examples "accessible"
    end
  end

  def submit_event_request(ohioid: "rb141412", duration: "2 hours", base_time: Date.today.next_occurring(:monday).middle_of_day, purpose: "Bobcat cage escape training", room: nil)
    fill_in "event[ohioid]", with: ohioid
    select(room.name, from: "Room") if room
    fill_in "Date", with: base_time
    fill_in "Time", with: base_time
    select duration, from: "Duration"
    fill_in "Purpose", with: purpose

    click_on "Request"
  end

  def should_be_on_confirmation_page
    expect(page).to have_content("Event request received")
  end
end
