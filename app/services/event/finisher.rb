class Event
  class Finisher
    def call
      Event
        .past
        .approved
        .select(&:past?)
        .each(&:finish!)
    end
  end
end
