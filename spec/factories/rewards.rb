FactoryBot.define do
  factory :reward do
    title { Faker::Lorem.word }
    association :question, factory: :question
  end
end
