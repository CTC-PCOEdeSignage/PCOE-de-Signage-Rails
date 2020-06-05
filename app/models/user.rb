class User < ApplicationRecord
  has_many :events

  validates_uniqueness_of :email
  validates_presence_of :email, :aasm_state
  before_save { self.email = self.email.downcase }

  include AASM
  aasm do
    state :quarantined, initial: true
    state :approved
    state :denied

    event :approve do
      transitions from: :quarantined, to: :approved
      transitions from: :denied, to: :approved
    end

    event :deny do
      transitions from: :quarantined, to: :denied
      transitions from: :approved, to: :denied
    end

    event :quarantine do
      transitions from: :approved, to: :quarantined
      transitions from: :denied, to: :quarantined
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
