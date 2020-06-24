require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    subject { create(:event) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }

    it { is_expected.to validate_presence_of(:purpose) }
    it { is_expected.to validate_presence_of(:duration) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:aasm_state) }
    it { is_expected.to validate_presence_of(:verification_identifier) }

    it { is_expected.to validate_length_of(:purpose).is_at_least(5) }

    it { is_expected.to validate_uniqueness_of(:verification_identifier) }
  end

  describe "scopes" do
    it ".needs_approval" do
      create(:event, purpose: "not included")
      create(:event, purpose: "INCLUDED", aasm_state: :verified)
      create(:event, purpose: "not included", aasm_state: :approved)
      create(:event, purpose: "INCLUDED", aasm_state: :declined)
      create(:event, purpose: "not included", aasm_state: :finished)

      need_approval = Event.needs_approval

      expect(need_approval.count).to eq(2)
      expect(need_approval.map(&:purpose)).to all(eq "INCLUDED")
    end

    it ".impacting" do
      create(:event, purpose: "INCLUDED")
      create(:event, purpose: "INCLUDED", aasm_state: :verified)
      create(:event, purpose: "INCLUDED", aasm_state: :approved)
      create(:event, purpose: "not included", aasm_state: :declined)
      create(:event, purpose: "INCLUDED", aasm_state: :finished)

      impacting = Event.impacting

      expect(impacting.count).to eq(4)
      expect(impacting.map(&:purpose)).to all(eq "INCLUDED")
    end

    it ".on_date" do
      create(:event, start_at: 1.hour.from_now, purpose: "Today")
      create(:event, start_at: 1.day.from_now, purpose: "Tomorrow")

      beginning_of_tomorrow = 1.day.from_now.beginning_of_day
      tomorrows_events = Event.on_date(beginning_of_tomorrow)

      expect(tomorrows_events.count).to eq(1)
      expect(tomorrows_events.map(&:purpose)).to all(eq "Tomorrow")
    end
  end

  describe "state machine" do
    subject { build(:event) }

    describe "states" do
      describe "when requested" do
        it { expect(subject.aasm_state).to eq("requested") }
        it { expect(subject).to allow_event(:verify) }
        it { expect(subject).to_not allow_event(:approve) }
        it { expect(subject).to_not allow_event(:decline) }
        it { expect(subject).to_not allow_event(:finish) }
      end

      describe "when verified" do
        before { subject.aasm_state = "verified" }

        it { expect(subject).to allow_event(:approve) }
        it { expect(subject).to allow_event(:decline) }
        it { expect(subject).to_not allow_event(:verify) }
        it { expect(subject).to_not allow_event(:finish) }
      end

      describe "when approved" do
        before { subject.aasm_state = "approved" }

        it { expect(subject).to allow_event(:decline) }
        it { expect(subject).to allow_event(:finish) }
        it { expect(subject).to_not allow_event(:verify) }
        it { expect(subject).to_not allow_event(:approve) }
      end

      describe "when declined" do
        before { subject.aasm_state = "declined" }

        it { expect(subject).to allow_event(:approve) }
        it { expect(subject).to_not allow_event(:verify) }
        it { expect(subject).to_not allow_event(:decline) }
        it { expect(subject).to_not allow_event(:finish) }
      end

      describe "when finished" do
        before { subject.aasm_state = "finished" }

        it { expect(subject).to_not allow_event(:verify) }
        it { expect(subject).to_not allow_event(:approve) }
        it { expect(subject).to_not allow_event(:decline) }
        it { expect(subject).to_not allow_event(:finish) }
      end
    end

    describe "events" do
      around do |example|
        freeze_time do
          example.run
        end
      end

      describe "on verify" do
        subject { build(:event, aasm_state: "requested") }

        it "sets verified_at" do
          expect(subject.verified_at).to_not be_present

          subject.verify

          expect(subject.verified_at).to eq(Time.current)
        end
      end

      describe "on approve" do
        subject { build(:event, aasm_state: "verified") }

        it "sets approved_at" do
          expect(subject.approved_at).to_not be_present

          subject.approve

          expect(subject.approved_at).to eq(Time.current)
        end
      end

      describe "on decline" do
        subject { build(:event, aasm_state: "verified") }

        it "sets approved_at" do
          expect(subject.declined_at).to_not be_present

          subject.decline

          expect(subject.declined_at).to eq(Time.current)
        end
      end

      describe "on finish" do
        subject { build(:event, aasm_state: "approved") }

        it "sets finished_at" do
          expect(subject.finished_at).to_not be_present

          subject.finish

          expect(subject.finished_at).to eq(Time.current)
        end
      end
    end
  end

  describe "#end_at" do
    let(:event) { build_stubbed(:event, start_at: 1.hour.from_now.beginning_of_hour, duration: 60) }

    it "caculates based on start_at and duration" do
      expect(event.end_at).to eq(2.hours.from_now.beginning_of_hour)
    end
  end
end
