require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    context 'user' do
      it { should belong_to :user }
    end

    context 'votable' do
      it { should belong_to :votable }
    end
  end

  describe 'validations' do
    context 'value' do
      it { should validate_inclusion_of(:value).in_array([ -1, 1 ]) }
    end

    context 'uniqueness user reward scope type & id' do
      subject { create(:vote, votable: create(:question)) }

      it { should validate_uniqueness_of(:user_id).scoped_to([ :votable_id, :votable_type ]) }
    end
  end

  describe 'votable - question' do
    it 'should be associated with a question' do
      vote = create(:vote, :for_question)

      expect(vote.votable).to be_a(Question)
    end
  end

  describe 'votable - answer' do
    it 'should be associated with an answer' do
      vote = create(:vote, :for_answer)

      expect(vote.votable).to be_a(Answer)
    end
  end
end
