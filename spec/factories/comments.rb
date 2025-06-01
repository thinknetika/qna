FactoryBot.define do
  factory :comment do
    author { association :user }
    body { Faker::Lorem.paragraph }
    commentable { nil }

    trait :for_question do
      commentable { create(:question) }
    end

    trait :for_answer do
      commentable { create(:answer) }
    end
  end
end
