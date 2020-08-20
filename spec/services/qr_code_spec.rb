require "rails_helper"

RSpec.describe QrCode, :type => :service do
  let(:room) { create(:room) }

  it "QrCode.data_url_for(room)" do
    svg = QrCode.data_url_for(room)

    expect(svg).to be_a String

    uri, svg_string = svg.split("base64,")
    expect(uri).to eq("data:image/svg+xml;")
    expect(svg_string).to end_with("==")
    expect(svg_string.length).to eq 70_504
  end
end
