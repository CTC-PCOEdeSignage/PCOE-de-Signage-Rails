FactoryBot.define do
  factory :event do
    user
    room
    start_at { 1.day.from_now.beginning_of_hour }
    duration { 60 }
    purpose { Faker::Lorem.paragraph }

    trait :requested do
      aasm_state { "requested" }
    end

    trait :verified do
      aasm_state { "verified" }
    end

    trait :approved do
      aasm_state { "approved" }
    end

    trait :declined do
      aasm_state { "declined" }
    end

    trait :finished do
      aasm_state { "finished" }
    end
  end
end
