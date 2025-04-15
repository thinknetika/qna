require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    context 'user rewards' do
      it { should have_many(:user_rewards).dependent(:destroy) }
      it { should have_many(:rewards).through(:user_rewards) }
    end

    context 'questions' do
      it { should have_many(:questions).with_foreign_key('author_id').dependent(:destroy) }
    end

    context 'answers' do
      it { should have_many(:answers).with_foreign_key('author_id').dependent(:destroy) }
    end

    context 'votes' do
      it { should have_many(:votes).dependent(:destroy) }
    end
  end

  describe 'validations' do
    context 'email' do
      it { should validate_presence_of :email }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end

    context 'password' do
      it { should validate_presence_of :password }
    end
  end

  describe '#owns?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:resource) { create(:question, author: user) }

    it 'returns true if the user owns the resource' do
      expect(user.owns?(resource)).to be_truthy
    end

    it 'returns false if the user does not own the resource' do
      resource.update(author: other_user)
      expect(user.owns?(resource)).to be_falsy
    end
  end
end
