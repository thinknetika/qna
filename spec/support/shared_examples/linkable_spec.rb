require 'rails_helper'

RSpec.shared_examples 'Linkable' do
  subject { FactoryBot.create(described_class.to_s.underscore.to_sym) }

  context "votes" do
    it { should have_many(:links).dependent(:destroy) }
  end

  context 'nested attributes for links' do
    it { is_expected.to accept_nested_attributes_for(:links).allow_destroy(true) }
  end
end

