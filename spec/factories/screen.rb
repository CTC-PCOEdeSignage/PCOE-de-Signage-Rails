FactoryBot.define do
  factory :screen do
    name { Faker::FunnyName.unique.name }
    rotation { Screen.rotations.sample }
    layout { Screen.layouts.sample }
  end
end
