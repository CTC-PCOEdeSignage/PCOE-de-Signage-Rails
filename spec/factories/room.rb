FactoryBot.define do
  factory :room do
    name { Faker::FunnyName.name }
    building { Faker::FunnyName.name }
    room { Faker::Address.building_number }
  end
end
