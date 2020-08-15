module Rooms
  class BulkAvailability
    def initialize(params:)
      @params = params
    end

    def availability
      @availability ||=
        OpenStruct.new(
          rooms: rooms,
          room_availability: rooms_availability,
          schedule: recurring_schedule.occurrences,
          events: events,
        )
    end

    def persist!
      Event.transaction do
        decline_overlapping_events!
        save_recurring_events!
      end
    end

    private

    def decline_overlapping_events!
      rooms_availability.flat_map do |ra|
        recurring_schedule.occurrences.map do |occurence|
          ra.availability_at(occurence.begin)
        end
      end
        .select(&:blocking_event?)
        .map(&:blocking_event)
        .uniq
        .each(&:decline!)
    end

    def save_recurring_events!
      availability.tap { |a| a.events.each(&:save!) }
    end

    def rooms_availability
      @rooms_availability ||= Rooms::Availability.new(rooms: rooms).availability
    end

    def recurring_schedule
      @recurring_schedule ||= RecurringSchedule.new(params)
    end

    def rooms
      @rooms ||= Room.where(id: params["rooms"])
    end

    def events
      @events ||= begin
          rooms.map do |room|
            recurring_schedule.occurrences.map do |occurrence|
              start_date = occurrence.begin
              duration = occurrence.end - occurrence.begin

              Event.new user_id: auto_approved_user.id,
                        room_id: room.id,
                        start_at: start_date,
                        duration: duration,
                        aasm_state: "approved",
                        purpose: params["event_purpose"]
            end
          end
            .flatten
        end
    end

    def auto_approved_user
      @user ||= User.find_or_create_by(email: params["event_email"]) do |user|
        user.approve!
      end
    end

    attr_reader :params
  end
end
