class RoomDecorator < Draper::Decorator
  delegate_all

  def availability
    libcal_availability = object.libcal_availability
    return "Room Available Now" if libcal_availability.is_available_now?

    if libcal_availability.available_soon?
      time_in_words = h.time_ago_in_words(libcal_availability.next_available_start_time)

      "Room available in #{time_in_words}"
    else
      "Room not available soon; Try another room."
    end
  end

  def is_available_at?(time)
    object.libcal_availability.is_available_at?(time)
  end
end
