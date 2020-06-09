FactoryBot.define do
  factory :slide do
    name { Faker::Name.name }
    style { Slide::STYLE_OPTIONS.sample }
  end
end
