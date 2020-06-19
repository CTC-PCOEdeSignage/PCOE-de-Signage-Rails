class EventMailer < ApplicationMailer
  def validate_user(event)
    @event = event
    @user = event.user
    @settings_base = Settings.emails.verification

    mail to: @user.email, subject: @settings_base.subject
  end

  def approve(event)
    @event = event
    @user = event.user
    @settings_base = Settings.emails.approved

    mail to: @user.email, subject: @settings_base.subject
  end

  def decline(event)
    @event = event
    @user = event.user
    @settings_base = Settings.emails.declined

    mail to: @user.email, subject: @settings_base.subject
  end

  def finish(event)
    @event = event
    @user = event.user
    @settings_base = Settings.emails.post_event

    mail to: @user.email, subject: @settings_base.subject
  end
end
