require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "associations" do
    context 'author' do
      it { should belong_to(:author) }
    end

    context "best answer" do
      it { should belong_to(:best_answer).optional }
    end

    context "answers" do
      it { should have_many(:answers).dependent(:destroy) }
    end

    context "user_rewards" do
      it { should have_many(:user_rewards).dependent(:destroy) }
    end

    context 'rewards' do
      it { should have_one(:reward).dependent(:destroy) }
      it { should accept_nested_attributes_for :reward }
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
    context "title" do
      it { should validate_presence_of(:title) }
    end

    context "body" do
      it { should validate_presence_of(:body) }
    end
  end
end
