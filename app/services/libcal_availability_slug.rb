# frozen_string_literal: true

# This file is for testing only
# LibcalAvailabilitySlug is a shim to generate a LibCal-like response

class LibcalAvailabilitySlug
  def initialize(room)
    @room = room
  end

  def to_h
    { "availability" => { "room_id" => @room.id,
                         "group_id" => 14940,
                         "name" => @room.name,
                         "capacity" => 6,
                         "description" => "",
                         "directions" => "",
                         "image_url " => "PR203",
                         "timeslots_available" => random_timeslots.size,
                         "timeslots" => random_timeslots,
                         "last_updated" => "2018-06-01T13:20:40-04:00" } }
  end

  private

  BASE_ID = 627890180

  def random_timeslots
    @random_timeslots ||=
      5.times.map do |index|
        next unless should_show?

        { "id" => BASE_ID + index,
          "start" => (now_hour + index.hour).iso8601,
          "end" => (now_hour + index.hour + 1.hour).iso8601,
          "duration" => 60 }
      end.compact
  end

  def now_hour
    @now_hour ||= Time.current.change(min: 0, sec: 0, nsec: 0)
  end

  def should_show?
    Random.rand(100) % 2 == 0
  end
end
