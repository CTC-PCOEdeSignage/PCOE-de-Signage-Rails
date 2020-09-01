FactoryBot.define do
  factory :slide do
    name { Faker::Name.unique.name }
    style { Slide::STYLE_OPTIONS.sample }

    trait :all_schedule_slide do
      style { "_all-schedule-slide.html.erb" }
    end

    trait :image do
      style { "image" }
    end

    trait :markup do
      style { "markup" }
    end
  end
end
