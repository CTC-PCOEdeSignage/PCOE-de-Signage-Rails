require Rails.root.join("app", "jobs", "event_finisher_job")

schedule_file = "config/schedule.yml"
Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file)) if File.exist?(schedule_file)
