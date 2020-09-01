FactoryBot.define do
  factory :room do
    name { Faker::FunnyName.unique.name }
    building { Faker::FunnyName.name }
    room { Faker::Address.building_number }
  end
end
