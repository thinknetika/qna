require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:admin) { create :user, admin: true }
  let(:user) { create :user }
  let(:comment) { create :comment, :for_question, author: user }

  subject { CommentPolicy }

  permissions :new?, :create? do
    it_behaves_like 'comment creatable by authenticated user'
  end

  permissions :edit?, :update?, :destroy? do
    it_behaves_like 'comment accessible by admin author'
  end
end
