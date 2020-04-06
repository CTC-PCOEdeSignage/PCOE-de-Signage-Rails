FactoryBot.define do
  factory :room do
    name { Faker::FunnyName.name }
    building { Faker::FunnyName.name }
    room { Faker::FunnyName.name }
    libcal_identifier { Faker::Number.number }
  end
end
