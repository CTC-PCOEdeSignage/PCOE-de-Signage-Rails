class RoomDecorator < Draper::Decorator
  delegate_all

  def availability
    libcal_availability = object.libcal_availability
    return "Available Now" if libcal_availability.is_available_now?

    if libcal_availability.available_soon?
      start_time = libcal_availability.next_available_start_time.strftime("%l %p")

      "Available at #{start_time}"
    else
      "Not available soon; Try another room."
    end
  end

  def is_available_at?(time)
    object.libcal_availability.is_available_at?(time)
  end

  def available_class
    if object.libcal_availability.is_available_now?
      "available"
    end
  end
end
