require "rails_helper"

RSpec.describe Room::Availability, :type => :service do
  let(:room) { create(:room) }

  subject { room.availability }

  describe "#availability" do
    it "allows you to get availability for sunday" do
      availabilites = get_availability_for_next(:sunday)

      expect(availabilites).to all(be_not_available)
    end

    it "allows you to get availability for saturday" do
      availabilites = get_availability_for_next(:saturday)

      expect(availabilites).to all(be_not_available)
    end

    it "allows you to get availability for monday (a day with no events)" do
      availables, not_availables = get_availability_for_next(:monday).partition(&:available?)

      expect(availables.size).to eq(time_slots_for_hours(9))
      expect(not_availables.size).to eq(all_time_slots - time_slots_for_hours(9))
    end

    it "allows you to get availability for tuesday (a day with 1 event)" do
      start_at = Time.current.next_occurring(:tuesday).change(hour: 12)
      create(:event, start_at: start_at, duration: 120, room: room)
      availables, not_availables = get_availability_for_next(:tuesday).partition(&:available?)

      available_slots = time_slots_for_hours(9) - 4 # 4 time slots for the created event
      expect(availables.size).to eq(available_slots)
      expect(not_availables.size).to eq(all_time_slots - available_slots)
    end

    it "allows you to get availability for wednesday (a day with 2 events - one approved; one declined)" do
      start_at = Time.current.next_occurring(:wednesday).change(hour: 12)
      create(:event, :requested, start_at: start_at, duration: 120, room: room)
      create(:event, :declined, start_at: start_at + 3.hours, duration: 60, room: room)
      availables, not_availables = get_availability_for_next(:wednesday).partition(&:available?)

      available_slots = time_slots_for_hours(9) - 4 # 4 time slots for the requested event + 0 for declined event
      expect(availables.size).to eq(available_slots)
      expect(not_availables.size).to eq(all_time_slots - available_slots)
    end
  end

  describe "#next_available" do
    context "with no events" do
      it "get availability on any given monday" do
        travel_to Date.today.next_occurring(:monday).middle_of_day + 1.minute do
          expect(
            subject.next_available.time
          ).to eq(Time.current.change(min: 30))
        end
      end
    end

    context "with 1 event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, start_at: Time.current.beginning_of_hour, duration: 60, room: room)

          expect(
            subject.next_available.time
          ).to eq(1.hour.from_now.beginning_of_hour)
        end
      end
    end

    context "with 2 events (one approved, one declined" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :requested, start_at: Time.current.beginning_of_hour, duration: 60, room: room)
          create(:event, :declined, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.next_available.time
          ).to eq(1.hour.from_now.beginning_of_hour)
        end
      end
    end

    context "with all day event that forces you to span to 2nd day" do
      let(:tuesday) { Date.today.next_occurring(:tuesday).middle_of_day }
      it "get availability on any given tuesday" do
        travel_to tuesday + 1.minute do
          create(:event, start_at: tuesday.beginning_of_hour, duration: 10 * 60, room: room)

          expect(
            subject.next_available.time
          ).to eq((tuesday + 1.day).change(hour: 8))
        end
      end
    end
  end

  describe "#last_available" do
    context "with no events" do
      it "get availability on any given monday" do
        travel_to Date.today.next_occurring(:monday).middle_of_day + 1.minute do
          expect(
            subject.last_available.time
          ).to eq(Time.current.beginning_of_hour + 4.5.hours)
        end
      end
    end

    context "with 1 event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, start_at: Time.current.beginning_of_hour, duration: 60, room: room)

          expect(
            subject.last_available
          ).to eq(nil)
        end
      end
    end

    context "with 1 future approved event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :approved, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.last_available.time
          ).to eq(Time.current.change(min: 30))
        end
      end
    end

    context "with 1 future declined event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :declined, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.last_available.time
          ).to eq(Time.current.beginning_of_hour + 4.5.hours)
        end
      end
    end

    context "with 1 future verified event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :verified, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.last_available.time
          ).to eq(Time.current.change(min: 30))
        end
      end
    end

    context "with 2 events (one approved, one declined" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :requested, start_at: Time.current.beginning_of_hour, duration: 60, room: room)
          create(:event, :declined, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.last_available
          ).to eq(nil)
        end
      end
    end

    context "with all day event that forces you to span to 2nd day" do
      let(:tuesday) { Date.today.next_occurring(:tuesday).middle_of_day }
      it "get availability on any given tuesday" do
        travel_to tuesday + 1.minute do
          create(:event, start_at: tuesday.beginning_of_hour, duration: 10 * 60, room: room)

          expect(
            subject.last_available
          ).to eq(nil)
        end
      end
    end
  end

  describe "#available_now?" do
    context "with no events" do
      it "get availability on any given monday" do
        travel_to Date.today.next_occurring(:monday).middle_of_day + 1.minute do
          expect(
            subject.available_now?
          ).to eq(true)
        end
      end
    end

    context "with 1 event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, start_at: Time.current.beginning_of_hour, duration: 60, room: room)

          expect(
            subject.available_now?
          ).to eq(false)
        end
      end
    end

    context "with 2 events (one approved, one declined" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :declined, start_at: Time.current.beginning_of_hour, duration: 60, room: room)
          create(:event, :approved, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.available_now?
          ).to eq(true)
        end
      end
    end
  end

  describe "#closed_now?" do
    context "with no events" do
      it "get availability on any given sunday" do
        travel_to Date.today.next_occurring(:sunday).middle_of_day do
          expect(
            subject.closed_now?
          ).to eq(true)
        end
      end

      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day do
          expect(
            subject.closed_now?
          ).to eq(false)
        end
      end
    end

    context "with 1 event" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).beginning_of_day do
          create(:event, start_at: Date.today.next_occurring(:tuesday).middle_of_day, duration: 60, room: room)

          expect(
            subject.closed_now?
          ).to eq(true)
        end
      end
    end
  end

  describe "#availability_at" do
    let(:middle_of_day) { Time.current.floor_to(30.minutes) }

    context "with no events" do
      it "get availability on any given monday" do
        travel_to Date.today.next_occurring(:monday).middle_of_day + 1.minute do
          expect(
            subject.availability_at(middle_of_day)
          ).to be_a Room::Availability::Available
        end
      end
    end

    context "with 1 event" do
      around do |example|
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          example.run
        end
      end

      let!(:event) { create(:event, start_at: Time.current.beginning_of_hour, duration: 60, room: room) }

      it "get availability on any given tuesday" do
        availability = subject.availability_at(middle_of_day)
        expect(availability).to be_a Room::Availability::NotAvailable
        expect(availability.blocking_event?).to eq(true)
        expect(availability.blocking_event).to eq(event)
      end
    end

    context "with 2 events (one approved, one declined" do
      it "get availability on any given tuesday" do
        travel_to Date.today.next_occurring(:tuesday).middle_of_day + 1.minute do
          create(:event, :declined, start_at: Time.current.beginning_of_hour, duration: 60, room: room)
          create(:event, :approved, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.availability_at(middle_of_day)
          ).to be_a Room::Availability::Available

          expect(
            subject.availability_at(middle_of_day + 12.hours)
          ).to be_a Room::Availability::Closed
        end
      end
    end
  end

  describe "#available_between" do
    context "with no events" do
      let(:monday) { Date.today.next_occurring(:monday).middle_of_day }
      it "is available" do
        travel_to monday + 1.minute do
          expect(
            subject.available_between?(monday + 1.hour, monday + 2.hours)
          ).to eq(true)
        end
      end
    end

    context "with 1 event" do
      let(:tuesday) { Date.today.next_occurring(:tuesday).middle_of_day }

      it "is available after the event" do
        travel_to tuesday + 1.minute do
          create(:event, start_at: tuesday.beginning_of_hour, duration: 60, room: room)

          expect(
            subject.available_between?(tuesday + 1.hour, tuesday + 2.hours)
          ).to eq(true)
        end
      end
    end

    context "with 2 events (one approved, one declined" do
      let(:tuesday) { Date.today.next_occurring(:tuesday).middle_of_day }

      it "is available during a declined event" do
        travel_to tuesday + 1.minute do
          create(:event, :requested, start_at: Time.current.beginning_of_hour, duration: 60, room: room)
          create(:event, :declined, start_at: Time.current.beginning_of_hour + 1.hour, duration: 60, room: room)

          expect(
            subject.available_between?(tuesday + 1.hour, tuesday + 2.hours)
          ).to eq(true)
        end
      end
    end

    context "with all day event" do
      let(:tuesday) { Date.today.next_occurring(:tuesday).middle_of_day }

      it "is not available during an event" do
        travel_to tuesday + 1.minute do
          create(:event, start_at: tuesday.beginning_of_hour, duration: 10 * 60, room: room)

          expect(
            subject.available_between?(tuesday + 1.hour, tuesday + 2.hours)
          ).to eq(false)
        end
      end
    end
  end

  def get_availability_for_next(day_of_the_week)
    day = Date.today.next_occurring(day_of_the_week.to_sym)
    subject.availability(on: day)
  end

  def all_time_slots
    time_slots_for_hours(24)
  end

  def time_slots_for_hours(hours)
    hours * 2 # X hours * 30 minute increments
  end
end
