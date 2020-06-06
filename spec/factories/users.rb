FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: "ohio.edu") }

    trait :quarantined do
      aasm_state { "quarantined" }
    end
    trait :approved do
      aasm_state { "approved" }
    end
    trait :declined do
      aasm_state { "declined" }
    end
  end
end
