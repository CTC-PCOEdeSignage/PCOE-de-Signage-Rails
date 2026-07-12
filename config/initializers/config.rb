Config.setup do |config|
  config.fail_on_missing = true
  config.const_name = "Settings"
  config.env_prefix = "SETTINGS"
end

require Rails.root.join("lib/settings_schema")

# The config gem requires this file once during railtie preload (before Settings
# exists) and Rails loads it again as a regular initializer, so only validate on
# the second pass, once Settings has been loaded.
if defined?(Settings)
  errors = SettingsSchema.errors(Settings.to_hash)
  raise "Invalid settings: #{errors.to_sentence}" if errors.any?
end
