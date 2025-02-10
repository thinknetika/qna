FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    association :question
    association :author, factory: :user
  end

  trait :invalid_answer do
    body { nil }
  end
end
