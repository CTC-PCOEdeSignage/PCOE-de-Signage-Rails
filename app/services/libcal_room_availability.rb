class LibcalRoomAvailability
  def initialize(room, libcal_token)
    @room = room
    @libcal_token = libcal_token
  end

  def timeslots
    @timeslots ||=
      (request_availability.dig("availability", "timeslots") || []).map do |slot|
        {
          "id" => slot.dig("id"),
          "start" => Time.parse(slot.dig("start")),
          "end" => Time.parse(slot.dig("end")),
        }
      end
  end

  def is_available_now?
    is_available_at?(Time.now)
  end

  def is_available_at?(time)
    timeslots.any? { |slot| slot["start"] <= time && time <= slot["end"]}
  end

  def available_soon?
    !timeslots.empty?
  end

  def next_available_start_time
    return if timeslots.empty?

    timeslots.first["start"]
  end

  private

  def request_availability
    @request_availability ||= begin
      headers = { Authorization: "Bearer #{@libcal_token.auth_token}", accept: :json }
      request = RestClient.get(room_url, headers)

      # TODO: REMOVE model
      # For Testing Purposes
      # return LibcalAvailabilitySlug.new(@room).to_h
      JSON.parse(request.body)
    end
  end

  def room_url
    @room_url ||= "https://api2.libcal.com/1.1/room_availability?room_id=#{@room.libcal_identifier}"
  end
end
