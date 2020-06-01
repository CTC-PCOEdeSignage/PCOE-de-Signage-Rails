class User < ApplicationRecord
  has_many :events

  validates_uniqueness_of :email
  validates_presence_of :email, :aasm_state
  before_save { self.email = self.email.downcase }

  include AASM
  aasm do
    state :quarantined, initial: true
    state :whitelisted
    state :blacklisted

    event :whitelist do
      transitions from: :quarantined, to: :whitelisted
      transitions from: :blacklisted, to: :whitelisted
    end

    event :blacklist do
      transitions from: :quarantined, to: :blacklisted
      transitions from: :whitelisted, to: :blacklisted
    end

    event :quarantine do
      transitions from: :whitelisted, to: :quarantined
      transitions from: :blacklisted, to: :quarantined
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
