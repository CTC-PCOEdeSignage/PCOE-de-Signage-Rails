require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PcoeDeSignageRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.active_storage.service = :local
    config.active_job.queue_adapter = :delayed_job

    config.time_zone = "Eastern Time (US & Canada)"

    config.to_prepare do
      ActiveStorage::Attachment.include(RansackedAttributes)
    end
  end
end

require Rails.root.join("lib", "float_is_whole")
require Rails.root.join("lib", "parse_time_in_context")
require Rails.root.join("lib", "time_ranged_by_step")
