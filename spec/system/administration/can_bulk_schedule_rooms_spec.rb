require "rails_helper"

RSpec.describe "Can Bulk Schedule Rooms", :type => :system do
  let(:admin_user) { create(:admin_user, email: "czar@ohio.edu") }
  let!(:rooms) { create_list(:room, 2) }

  before do
    sign_in admin_user
    visit admin_bulk_schedule_path
  end

  around do |example|
    travel_to Date.today.next_occurring(:monday).middle_of_day do
      example.run
    end
  end

  describe "allows checking rooms" do
    it "should output table" do
      set_daily_event
      fill_in "Event purpose", with: "Many People Do things"
      fill_in "Start time", with: Date.today.time_parse_in_context("1 PM")
      fill_in "Duration", with: 60
      fill_in "End date", with: 1.month.from_now
      check rooms.first.name

      click_button "Check Dates"

      find(".results")
      within(".results") do
        expect(page).to have_content("Events")
        expect(page).to have_content(rooms.first.name.upcase)
      end
    end
  end

  describe "allows scheduling rooms" do
    it "should require you to confirm" do
      set_daily_event
      fill_in "Event purpose", with: "Many People Do things"
      fill_in "Start time", with: Date.today.time_parse_in_context("1 PM")
      fill_in "Duration", with: 60
      fill_in "End date", with: 1.month.from_now
      check rooms.first.name

      accept_alert { click_button "Schedule Dates" }
    end

    it "should schedule events" do
      set_daily_event
      fill_in "Event purpose", with: "Many People Do things"
      fill_in "Start time", with: Date.today.time_parse_in_context("1 PM")
      fill_in "Duration", with: 60
      fill_in "End date", with: 1.month.from_now
      check rooms.first.name

      accept_alert { click_button "Schedule Dates" }
      find(".results")
      within(".results") do
        expect(page).to have_content("Events")
        expect(page).to have_content("Scheduled 32 events")
      end

      expect(Event.approved.count).to eq(32)
    end

    context "when there is an overlapping event" do
      let(:room) { rooms.first }
      let!(:existing_event) do
        create(:event,
               :approved,
               room: room,
               start_at: 1.day.from_now.to_date.time_parse_in_context("10 am"),
               duration: 6.hours)
      end

      it "should schedule new event and decline old event" do
        set_daily_event
        fill_in "Event purpose", with: "Many People Do things"
        fill_in "Start time", with: Date.today.time_parse_in_context("1 PM")
        fill_in "Duration", with: 60
        fill_in "End date", with: 1.month.from_now
        check room.name

        accept_alert { click_button "Schedule Dates" }
        find(".results")
        within(".results") do
          expect(page).to have_content("Events")
          expect(page).to have_content("Scheduled 32 events and declined any overlapping")
        end

        expect(Event.approved.count).to eq(32)

        expect(existing_event.reload).to be_declined
      end
    end
  end

  def set_daily_event
    script = <<-SCRIPT
      const recurringRule = document.getElementById("recurring_rule");
      const customOption = document.createElement("option");
      customOption.text = "Custom";
      customOption.value = '#{IceCube::Rule.daily.to_json}';
      recurringRule.add(customOption);
    SCRIPT
    execute_script(script)

    select "Custom", from: "Recurring Rule"
  end
end
