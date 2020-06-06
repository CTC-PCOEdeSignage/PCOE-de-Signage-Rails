class EventMailer < ApplicationMailer
  def validate_user(event)
    @event = event
    @user = event.user
    @config_keys = ["emails", "verification"]

    mail to: @user.email, subject: SystemConfiguration.get(*@config_keys, "subject")
  end

  def approve(event)
    @event = event
    @user = event.user
    @config_keys = ["emails", "approved"]

    mail to: @user.email, subject: SystemConfiguration.get(*@config_keys, "subject")
  end

  def decline(event)
    @event = event
    @user = event.user
    @config_keys = ["emails", "declined"]

    mail to: @user.email, subject: SystemConfiguration.get(*@config_keys, "subject")
  end
end
