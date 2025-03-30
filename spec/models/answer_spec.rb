require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "validations" do
    context "body" do
      it { should validate_presence_of(:body) }
    end
  end

  describe "associations" do
    context "answers" do
      it { should belong_to(:question) }
    end

    context "files" do
      it { should have_many_attached(:files) }
    end
  end
end
