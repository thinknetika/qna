FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end

  trait :invalid_question do
    title { nil }
  end
end
