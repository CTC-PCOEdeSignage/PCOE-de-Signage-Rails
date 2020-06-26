class EventFinisherJob
  include Sidekiq::Worker

  def perform
    Rails.logger.info "Running Event Finisher - #{Time.current}"
    Rails.logger.flush

    Event::Finisher.new.call
  end
end
