# Validates the shape of the application settings hash (see config/settings.yml).
# Each check is a bare `===` matcher: Regexp, Class, or Proc.
module SettingsSchema
  FILLED = /\S/ # non-blank string (Regexp#=== is false for non-strings)
  TIME = /\d{1,2}\s(am|pm|AM|PM)/
  INT_LIST = ->(value) { value.is_a?(Array) && !value.empty? && value.all?(Integer) }

  CHECKS = {
    [:domain] => FILLED,
    [:emails, :from] => FILLED,
    [:emails, :signature] => FILLED,
    [:duration, :default] => Integer,
    [:duration, :options] => INT_LIST,
    [:limits, :events_in_future] => Integer,
    [:limits, :days_in_future] => Integer
  }

  %i(requested pending approved declined finished room_policies).each do |page|
    CHECKS[[:web, page]] = FILLED
  end

  %i(verification approved declined finish request_approval).each do |email_template|
    CHECKS[[:emails, email_template, :subject]] = FILLED
    CHECKS[[:emails, email_template, :body]] = FILLED
  end

  %i(sunday monday tuesday wednesday thursday friday saturday).each do |day|
    CHECKS[[:availability, day, :start]] = TIME
    CHECKS[[:availability, day, :end]] = TIME
  end

  CHECKS.freeze

  def self.errors(hash)
    CHECKS.reject { |path, check| check === dig(hash, path) }
      .map { |path, _| "#{path.join(".")} is missing or invalid" }
  end

  def self.dig(hash, path)
    hash.dig(*path) if hash.is_a?(Hash)
  rescue TypeError # intermediate node is a scalar, e.g. web: "oops"
    nil
  end
end
