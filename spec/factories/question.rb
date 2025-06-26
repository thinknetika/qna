FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    association :author, factory: :user
  end

  trait :without_author do
    author { nil }
  end

  trait :invalid_question do
    title { nil }
  end

  trait :with_question_files do
    after(:build) do |question, evaluator|
      files = [
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'rails_helper.rb'), 'text/plain'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'spec_helper.rb'), 'text/plain')
      ]
      evaluator.files = files
    end
  end
end
