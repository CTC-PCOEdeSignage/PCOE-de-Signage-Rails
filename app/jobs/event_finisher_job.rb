class EventFinisherJob < CronJob
  self.cron_expression = "5 * * * *"

  def perform
    Rails.logger.info "Running Event Finisher - #{Time.current}"
    Rails.logger.flush

    Event::Finisher.new.call
  end
end
