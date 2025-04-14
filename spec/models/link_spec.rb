require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validation' do
    context 'name' do
      it { should validate_presence_of :name }
    end

    context 'url' do
      context 'url presence' do
        it { should validate_presence_of :url }
      end

      context 'url valid' do
        it { should allow_value('https://example.com/').for(:url) }
      end

      context 'url invalid' do
        it { should_not allow_value('//example.com/').for(:url) }
      end
    end
  end

  describe 'association' do
    it { should belong_to :linkable }
  end
end
