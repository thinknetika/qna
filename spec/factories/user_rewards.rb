FactoryBot.define do
  factory :user_reward do
    association :user
    association :reward
    association :question
  end
end
