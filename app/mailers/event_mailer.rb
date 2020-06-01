class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.validate_user.subject
  #
  def validate_user(event:)
    user = event.user
    @event = event

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.approve.subject
  #
  def approve(event:)
    user = event.user
    @event = event

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.decline.subject
  #
  def decline(event:)
    user = event.user
    @event = event

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.pending.subject
  #
  def pending(event:)
    user = event.user
    @event = event

    mail to: user.email
  end
end
