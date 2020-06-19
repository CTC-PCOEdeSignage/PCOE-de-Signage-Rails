class ApplicationMailer < ActionMailer::Base
  default from: -> { Settings.emails.from }
  layout "mailer"
end
