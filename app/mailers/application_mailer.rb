class ApplicationMailer < ActionMailer::Base
  default from: -> { SystemConfiguration.get("emails", "from") }
  layout "mailer"
end
