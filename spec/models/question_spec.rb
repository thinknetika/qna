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
    context "answers" do
      it { should have_many(:answers).dependent(:destroy) }
    end
  end
end
