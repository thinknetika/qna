require 'rails_helper'

RSpec.describe UserReward, type: :model do
  describe 'associations' do
    context "users" do
      it { should belong_to(:user) }
    end

    context "rewards" do
      it { should belong_to(:reward) }
    end

    context "questions" do
      it { should belong_to(:question) }
    end
  end

  describe 'validations' do
    context 'uniqueness user reward scope type & id' do
      let!(:user_reward) { create(:user_reward) }

      it { should validate_uniqueness_of(:reward_id).scoped_to([ :question_id]) }
    end
  end
end
