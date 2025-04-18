require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Linkable'

  describe "associations" do
    context "question" do
      it { should belong_to(:question) }
    end

    context 'author' do
      it { should belong_to(:author) }
    end

    context 'links' do
      it { should have_many(:links).dependent(:destroy) }
      it { should accept_nested_attributes_for :links }
    end

    context "files" do
      it { should have_many_attached(:files) }
    end
  end

  describe "validations" do
    context "body" do
      it { should validate_presence_of(:body) }
    end
  end
end
