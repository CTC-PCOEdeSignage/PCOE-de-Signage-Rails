require "rails_helper"

RSpec.xdescribe EventRequestForm, :type => :form do
  let(:room) { create(:room) }
  let(:params) do
    {
      email: "rufus",
      room_id: room.id,
      start_at: 1.day.from_now.beginning_of_hour,
      duration: 60,
      purpose: Faker::Lorem.paragraph,
    }
  end
  subject { EventRequestForm.from_params(params) }

  it "should be valid" do
    subject.valid?
    expect(subject.errors).to be_empty
  end
end
