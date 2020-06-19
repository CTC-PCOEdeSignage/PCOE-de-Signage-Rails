RSpec.shared_examples "accessible" do
  it "should be accessible" do
    expect(page).to be_accessible
  end
end

RSpec.shared_examples "event details" do |event_var_name|
  it "should contain event details" do
    event = send(event_var_name)

    expect(page).to have_content(event.purpose)
    expect(page).to have_content(event.start_at.to_formatted_s(:long))
  end
end
