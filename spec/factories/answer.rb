FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    association :question
    association :author, factory: :user
  end

  trait :invalid_answer do
    body { nil }
  end

  trait :with_answer_files do
    after(:build) do |answer, evaluator|
      files = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'spec_helper.rb'), 'text/plain')
      ]
      evaluator.files = files
    end
  end
end
