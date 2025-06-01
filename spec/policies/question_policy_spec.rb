require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:admin) { create :user, admin: true }
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  subject { AnswerPolicy }

  permissions :new?, :create? do
    it_behaves_like 'question creatable by authenticated user'
  end

  permissions :edit?, :update?, :destroy? do
    it_behaves_like 'question accessible by admin author'
  end
end
