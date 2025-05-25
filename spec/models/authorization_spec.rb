require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'associations' do
    context 'user' do
      it { should belong_to :user }
    end
  end

  describe 'validations' do
    context 'provider' do
      it { should validate_presence_of :provider }
    end

    context 'uid' do
      it { should validate_presence_of :uid }
    end
  end
end
