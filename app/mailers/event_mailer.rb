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
    @settings_base = Settings.emails.finish

    mail to: @user.email, subject: @settings_base.subject
  end

  def request_approval(event)
    emails = AdminUser.receive_event_approvals.map(&:email)
    @event = event
    @user = event.user
    @settings_base = Settings.emails.request_approval

    return unless emails.any?

    mail to: emails, subject: @settings_base.subject
  end
end
