FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.unique.email }
    password { "abcd1234" }
    password_confirmation { "abcd1234" }
  end
end
