class RoomDecorator < Draper::Decorator
  delegate_all

  def available_class
    available_class_for(Time.current.floor_to(30.minutes))
  end

  def availability
    case
    when room_availability.available_now?
      "Room Available Now"
    when room_availability.closed_now?
      "Room Closed"
    else
      next_available = room_availability.next_available.time

      if next_available.to_date == Date.today
        "Available at #{next_available.to_formatted_s(:hour_min_ampm)}"
      else
        "Not available soon; Try another room."
      end
    end
  end

  def is_available_at?(time)
    room_availability.available_between?(time, time + 30.minutes)
  end

  def available_class_for(time)
    case room_availability.availability_at(time)
    when Room::Availability::Available
      "available"
    when Room::Availability::NotAvailable
      "unavailable"
    when Room::Availability::Closed
      "closed"
    end
  end

  private

  def room_availability
    @room_availability ||= object.availability
  end
end
