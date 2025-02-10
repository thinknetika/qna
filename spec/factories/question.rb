FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    association :author, factory: :user
  end

  trait :invalid_question do
    title { nil }
  end
end
