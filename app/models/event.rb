class Event < ApplicationRecord
  validates_presence_of :purpose, :start_at, :duration, :aasm_state
  validates_length_of :purpose, minimum: 5

  validates_presence_of :verification_identifier
  validates_uniqueness_of :verification_identifier

  belongs_to :user
  belongs_to :room

  after_initialize { self.verification_identifier ||= SecureRandom.base64(16) }

  include AASM

  aasm do
    state :requested, initial: true
    state :verified
    state :approved
    state :declined
    state :finished

    event :verify do
      transitions from: :requested, to: :verified
    end

    event :approve do
      transitions from: :verified, to: :approved
      transitions from: :declined, to: :approved

      after Senders::EventApprovedEmail
    end

    event :decline do
      transitions from: :verified, to: :declined
      transitions from: :approved, to: :declined

      after Senders::EventDeclinedEmail
    end

    event :finish do
      transitions from: :approved, to: :finished

      after Senders::EventFinishedEmail
    end

    after_all_transitions do
      ts_setter = %(#{aasm.to_state}_at=)
      respond_to?(ts_setter) && send(ts_setter, ::Time.current)
    end
  end

  def details
    output =
      attributes
        .slice("start_at", "duration", "purpose")

    output["start_at"] = output["start_at"].to_formatted_s(:long)

    duration_unit = output["duration"] < 60 ? "min" : "hour"
    duration_value = output["duration"] < 60 ? output["duration"] : output["duration"] / 60
    output["duration"] = [duration_value, duration_unit.pluralize(duration_value)].join(" ")

    output
  end
end
