FactoryBot.define do
  factory :vote do
    association :user
    value { 1 }
    votable { nil }

    trait :for_question do
      votable { create(:question) }
    end

    trait :for_answer do
      votable { create(:answer) }
    end
  end
end
