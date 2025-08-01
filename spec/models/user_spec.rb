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

    context 'authorizations' do
      it { should have_many(:authorizations) }
    end

    context 'question_subscriptions' do
      it { should have_many(:question_subscriptions).dependent(:destroy) }
    end

    context 'subscribed_questions' do
      it { should have_many(:subscribed_questions).through(:question_subscriptions).source(:question) }
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

  describe '#subscribed_to?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when user has active subscription' do
      before { create(:question_subscription, user: user, question: question, is_active: true) }

      it 'returns true' do
        expect(user.subscribed_to?(question)).to be true
      end
    end

    context 'when user has inactive subscription' do
      before { create(:question_subscription, user: user, question: question, is_active: false) }

      it 'returns false' do
        expect(user.subscribed_to?(question)).to be false
      end
    end

    context 'when user has no subscription' do
      it 'returns false' do
        expect(user.subscribed_to?(question)).to be false
      end
    end
  end

  describe '.find_for_ouath' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
