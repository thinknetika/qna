require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'email' do
      it { should validate_presence_of :email }
    end

    context 'password' do
      it { should validate_presence_of :password }
    end
  end

  describe 'associations' do
    context 'user rewards' do
      it { should have_many(:user_rewards).dependent(:destroy) }
      it { should have_many(:rewards).through(:user_rewards) }
    end
  end
end
