FactoryBot.define do
  factory :question_subscription do
    user
    question
    is_active { true }
  end
end
