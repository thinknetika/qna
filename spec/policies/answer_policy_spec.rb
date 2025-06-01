require 'rails_helper'


RSpec.describe AnswerPolicy, type: :policy do
  let(:admin) { create :user, admin: true }
  let(:user) { create :user }
  let(:answer) { create :answer, author: user }

  subject { AnswerPolicy }

  permissions :new?, :create? do
    it_behaves_like 'answer creatable by authenticated user'
  end

  permissions :edit?, :update?, :destroy? do
    it_behaves_like 'answer accessible by admin author'
  end
end
