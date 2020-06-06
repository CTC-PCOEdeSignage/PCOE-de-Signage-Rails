FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: "ohio.edu") }
  end
end
