require "rails_helper"

RSpec.describe Event, type: :model do
  describe "validations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:room) }

    it { is_expected.to validate_presence_of(:purpose) }
    it { is_expected.to validate_presence_of(:duration) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:aasm_state) }

    it { is_expected.to validate_length_of(:purpose).is_at_least(5) }
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
end
