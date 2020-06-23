class User < ApplicationRecord
  include HasDurationOptions

  has_many :events
  has_many :future_events, -> { future }, class_name: "Event"

  validates :email, presence: true, uniqueness: true, formatted_email: true
  validates_presence_of :aasm_state
  validates_numericality_of :events_in_future, allow_nil: true, only_integer: true, greater_than_or_equal_to: 1
  validates_numericality_of :days_in_future, allow_nil: true, only_integer: true, greater_than_or_equal_to: 1

  before_save { self.email = self.email.downcase }

  include AASM
  aasm do
    state :quarantined, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :quarantined, to: :approved
      transitions from: :declined, to: :approved
    end

    event :decline do
      transitions from: :quarantined, to: :declined
      transitions from: :approved, to: :declined
    end

    event :quarantine do
      transitions from: :approved, to: :quarantined
      transitions from: :declined, to: :quarantined
    end
  end

  def name
    if first_name.presence && last_name.presence
      [last_name, first_name].join(", ")
    else
      email
    end
  end

  def ohioid
    return unless email?

    email.split("@").first
  end
end
