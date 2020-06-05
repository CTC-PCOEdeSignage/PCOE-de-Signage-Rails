require "rails_helper"

RSpec.describe QrCode, :type => :service do
  let(:room) { create(:room) }

  it "QrCode.data_url_for(room)" do
    png = QrCode.data_url_for(room)

    expect(png).to be_a String
    expect(png).to include("data:image/png;base64")
  end
end
