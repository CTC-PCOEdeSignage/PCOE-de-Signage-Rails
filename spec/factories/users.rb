FactoryBot.define do
  factory :user do
    email { Faker::Name.unique.last_name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
