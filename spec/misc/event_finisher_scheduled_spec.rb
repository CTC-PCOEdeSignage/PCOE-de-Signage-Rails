require "rails_helper"

RSpec.describe "event_finisher cron job" do
  # If any of these tests are failing, you will need to manually
  # remove all cron jobs (using Sidekiq cron web interface) and
  # then re-run the test suite.
  before { EventFinisherJob.schedule }

  it "should be scheduable" do
    expect(EventFinisherJob).to respond_to(:schedule)
    expect(EventFinisherJob).to respond_to(:scheduled?)
  end

  it "should happen ever hour; 5 after the hour" do
    expect(EventFinisherJob.cron_expression).to eq("5 * * * *")
  end
end
