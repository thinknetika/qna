require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "validations" do
    context "title" do
      it { should validate_presence_of(:title) }
    end

    context "body" do
      it { should validate_presence_of(:body) }
    end
  end

  describe "associations" do
    context 'links' do
      it { should have_many(:links).dependent(:destroy) }
      it { should accept_nested_attributes_for :links}
    end

    context "answers" do
      it { should have_many(:answers).dependent(:destroy) }
      it { should accept_nested_attributes_for :links }
    end

    context "files" do
      it { should have_many_attached(:files) }
    end
  end
end
