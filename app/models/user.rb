class User < ApplicationRecord
  include HasDurationOptions

  has_many :events

  validates :email, presence: true, uniqueness: true, formatted_email: true
  validates_presence_of :aasm_state

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
end
