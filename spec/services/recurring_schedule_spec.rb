require "rails_helper"

RSpec.describe RecurringSchedule, type: :service do
  let(:rule) { IceCube::Rule.weekly }
  let(:params) do
    { "recurring_rule" => rule.to_hash.to_json }
  end

  subject { RecurringSchedule.new(params) }

  around do |example|
    travel_to Date.parse("1/1/2020") do
      example.run
    end
  end

  it { expect(subject.occurrences.length).to eq(14) }
  it { expect(subject.occurrences).to all(be_a(Range)) }

  context "with duration" do
    before { params["duration"] = "1800" }

    it "should have the set duration" do
      subject.occurrences.each do |occurrence|
        expect(occurrence.last - occurrence.first).to eq(1800)
      end
    end
  end

  context "with start_time" do
    before { params["start_time"] = "3 pm" }

    it "should have the set start time" do
      subject.occurrences.each do |occurrence|
        expect(occurrence.first.hour).to eq(15)
        expect(occurrence.last.hour).to eq(16)
      end
    end
  end

  context "with end_date" do
    before { params["end_date"] = 6.months.from_now.to_date.to_s }

    it "should go up to end_date" do
      expect(subject.occurrences.size).to eq(27)

      subject.occurrences.last.tap do |occurrence|
        expect(occurrence.last.to_date).to be <= 6.months.from_now
      end
    end
  end
end
