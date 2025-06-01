require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    context 'author' do
      it { should belong_to(:author) }
    end

    context 'commentable' do
      it { should belong_to :commentable }
    end

    context 'commentable - question' do
      it 'should be associated with a question' do
        comment = create(:comment, :for_question)

        expect(comment.commentable).to be_a(Question)
      end
    end

    context 'commentable - answer' do
      it 'should be associated with an answer' do
        comment = create(:comment, :for_answer)

        expect(comment.commentable).to be_a(Answer)
      end
    end
  end

  describe "validations" do
    context "body" do
      it { should validate_presence_of(:body) }
    end
  end
end
