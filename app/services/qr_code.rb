require "rqrcode"
require "base64"

class QrCode
  def self.data_url_for(room)
    new(room).as_data_url
  end

  def initialize(room)
    @room = room
  end

  def as_data_url
    "data:image/svg+xml;base64,#{Base64.strict_encode64(as_svg)}"
  end

  private

  def as_svg
    qr_code
      .as_svg(
        bit_depth: 1,
        border_modules: 2, # only a little border
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        file: nil,
        resize_exactly_to: false,
        resize_gte_to: false,
      )
      .to_s
  end

  def qr_code
    @qr_code ||= RQRCode::QRCode.new(routes.new_room_event_request_url(room_id: room.id))
  end

  def routes
    Rails.application.routes.url_helpers
  end

  attr_reader :room
end
