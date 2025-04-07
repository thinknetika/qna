require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    context 'title' do
      it { should validate_presence_of(:title) }
    end
  end

  describe 'associations' do
    context 'image' do
      it { should have_one(:image_attachment) }
      it { should have_one(:image_blob) }
    end

    context 'user rewards' do
      it { should have_many(:user_rewards).dependent(:destroy) }
      it { should have_many(:user).through(:user_rewards) }
    end

    context 'question' do
      it { should belong_to(:question) }
    end
  end
end

