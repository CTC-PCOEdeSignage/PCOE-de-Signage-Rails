Config.setup do |config|
  config.fail_on_missing = true
  config.const_name = "Settings"
  config.env_prefix = "SETTINGS"

  config.schema do
    required(:domain).filled

    required(:web).hash do
      required(:requested).filled(:string)
      required(:pending).filled(:string)
      required(:approved).filled(:string)
      required(:declined).filled(:string)
      required(:finished).filled(:string)
      required(:room_policies).filled(:string)
    end

    required(:emails).hash do
      required(:from).filled(:string)
      required(:signature).filled(:string)

      %i(verification approved declined post_event).each do |email_template|
        required(email_template).hash do
          required(:subject).filled(:string)
          required(:body).filled(:string)
        end
      end
    end

    required(:duration).hash do
      required(:default).filled(:integer)
      required(:options).array(:integer, min_size?: 1)
    end

    required(:limits).hash do
      required(:events_in_future).filled(:integer)
      required(:days_in_future).filled(:integer)
    end

    required(:availability).hash do
      %i(sunday monday tuesday wednesday thursday friday saturday).each do |day|
        required(day).hash do
          required(:start).value(format?: /\d{1,2}\s(am|pm|AM|PM)/)
          required(:end).value(format?: /\d{1,2}\s(am|pm|AM|PM)/)
        end
      end
    end
  end
end
