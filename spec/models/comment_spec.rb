require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    context 'user' do
      it { should belong_to :user }
    end

    context 'commentable' do
      it { should belong_to :commentable }
    end
  end

  describe 'commentable - question' do
    it 'should be associated with a question' do
      comment = create(:comment, :for_question)

      expect(comment.commentable).to be_a(Question)
    end
  end

  describe 'commentable - answer' do
    it 'should be associated with an answer' do
      comment = create(:comment, :for_answer)

      expect(comment.commentable).to be_a(Answer)
    end
  end
end
