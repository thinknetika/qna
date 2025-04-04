require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value('https://example.com/').for(:url) }
  end

  describe 'association' do
    it { should belong_to :linkable }
  end
end
