require "rails_helper"

RSpec.describe SystemConfiguration, :type => :service, focus: true do
  it "allows you to get system domain" do
    expect(subject.get(:domain)).to eq("ohio.edu")
  end

  it "allows you to get a nested email" do
    expect(subject.get(:emails, :pending_event, :subject)).to eq("Test Subject")
    expect(subject.get(:emails, :pending_event, :body)).to match(/multiple/)
    expect(subject.get(:emails, :pending_event, :body)).to include("\n")
  end
  it "raises error if key not found" do
    expect { subject.get(:deep, :unfound, :key) }.to raise_error SystemConfiguration::KeyNotFound, "deep->unfound->key"
  end
end
