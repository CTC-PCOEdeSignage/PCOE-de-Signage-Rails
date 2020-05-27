class User < ApplicationRecord
  validates_uniqueness_of :email
  validates_presence_of :email, :first_name, :last_name, :aasm_state

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
end
