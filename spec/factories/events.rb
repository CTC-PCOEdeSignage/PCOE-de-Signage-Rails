FactoryBot.define do
  factory :event do
    user
    room
    start_at { 1.day.from_now.beginning_of_hour }
    duration { 60 }
    purpose { Faker::Lorem.paragraph }
  end
end
