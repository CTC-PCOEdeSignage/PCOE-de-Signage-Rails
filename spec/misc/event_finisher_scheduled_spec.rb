require "rails_helper"

RSpec.describe "event_finisher cron job" do
  # If any of these testse are failing, you will need to manually
  # remove all cron jobs (using Sidekiq cron web interface) and
  # then re-run the test suite.
  subject { Sidekiq::Cron::Job.find "event_finisher" }

  it "should be scheduled" do
    expect(subject).to be_present
  end

  it "should happen ever hour; 5 after the hour" do
    expect(subject.cron).to eq("5 * * * *")
  end
end
