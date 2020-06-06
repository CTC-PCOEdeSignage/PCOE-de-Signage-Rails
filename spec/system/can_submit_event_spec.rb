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

  it "should allow you to request event and create user end event" do
    submit_event_request

    user, event = User.first, Event.first

    expect(User.count).to eq(1)
    expect(Event.count).to eq(1)
    expect(user.email).to eq("rufus142@ohio.edu")
    expect(event.start_at).to eq(1.day.from_now.beginning_of_hour)
    expect(event.duration).to eq(120)
    expect(event.purpose).to eq("Bobcat cage escape training")
  end

  it "should redirect to a confirmation page" do
    submit_event_request

    expect(page).to have_content("Event request received")
  end

  it "should email a verification email" do
    expect { submit_event_request }.to change { ActionMailer::Base.deliveries.size }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include("rufus142@ohio.edu")
    expect(mail.body.encoded).to include("Verify")
  end

  def submit_event_request(ohioid: "rufus142", duration: "2 hrs", base_time: 1.day.from_now.beginning_of_hour, purpose: "Bobcat cage escape training")
    fill_in "event[ohioid]", with: ohioid
    fill_in "Date", with: base_time
    fill_in "Time", with: base_time
    select duration, from: "Duration"
    fill_in "Purpose", with: purpose

    click_on "Request"
  end
end
