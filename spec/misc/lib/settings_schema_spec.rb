require "rails_helper"

RSpec.describe SettingsSchema do
  let(:settings) { Settings.to_hash }

  subject(:errors) { described_class.errors(settings) }

  it "reports no errors for valid settings" do
    expect(errors).to be_empty
  end

  it "reports a missing nested key by its dot-path" do
    settings[:emails].delete(:from)

    expect(errors).to eq(["emails.from is missing or invalid"])
  end

  it "reports a missing top-level key" do
    settings.delete(:domain)

    expect(errors).to eq(["domain is missing or invalid"])
  end

  it "reports a wrong type" do
    settings[:duration][:default] = "60"

    expect(errors).to eq(["duration.default is missing or invalid"])
  end

  it "reports a badly formatted time" do
    settings[:availability][:monday][:start] = "morning"

    expect(errors).to eq(["availability.monday.start is missing or invalid"])
  end

  it "reports an empty or non-integer duration options list" do
    settings[:duration][:options] = []

    expect(errors).to eq(["duration.options is missing or invalid"])
  end

  it "reports all nested paths when a hash is replaced by a scalar" do
    settings[:web] = "oops"

    expect(errors).to match_array(
      %w(requested pending approved declined finished room_policies)
        .map { |page| "web.#{page} is missing or invalid" }
    )
  end

  it "reports every path when given nil" do
    expect(described_class.errors(nil).length).to eq(described_class::CHECKS.length)
  end
end
