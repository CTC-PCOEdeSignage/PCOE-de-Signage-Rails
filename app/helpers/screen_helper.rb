# frozen_string_literal: true

module ScreenHelper
  def qr_code(room)
    content_tag(:div, class: "qrcode") do
      image_tag(QrCode.data_url_for(room))
    end
  end

  def now_time
    # Hour Minute AM/PM
    Time.now.strftime("%l:%M %p")
  end

  def dual_layout?
    @screen.layout == "dual"
  end

  def single_layout?
    @screen.layout == "single"
  end

  def screen_rotation_class
    "rotate-#{@screen.rotation}"
  end

  def slide_length
    @slide_length
  end

  def next_slide_url
    @next_slide_url
  end

  def too_many_rooms?
    room_count = @screen.rooms.count

    (single_layout? && room_count > 1) ||
      (dual_layout? && room_count > 2)
  end

  def no_playlist?
    !@screen.playlist.presence
  end

  def arrow
    content_tag(:div, class: "arrow") do
      image_tag("arrow.png", width: "100px")
    end
  end
end
