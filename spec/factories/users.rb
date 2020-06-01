FactoryBot.define do
  factory :user do
    email { Faker::Name.unique.last_name }
  end
end
