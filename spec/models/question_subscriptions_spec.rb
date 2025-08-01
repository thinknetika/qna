require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  describe "associations" do
    context "user" do
      it { should belong_to(:user) }
    end

    context "question" do
      it { should belong_to(:question) }
    end
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context "user_id uniqueness" do
      before { create(:question_subscription, user: user, question: question) }

      it "should validate uniqueness of user_id scoped to question" do
        should validate_uniqueness_of(:user_id).scoped_to(:question_id)
      end
    end
  end

  describe "scopes" do
    let!(:active_subscription) { create(:question_subscription, is_active: true) }
    let!(:inactive_subscription) { create(:question_subscription, is_active: false) }

    context ".active" do
      it "returns only active subscriptions" do
        expect(QuestionSubscription.active).to include(active_subscription)
        expect(QuestionSubscription.active).not_to include(inactive_subscription)
      end
    end
  end

  describe "default values" do
    let(:subscription) { build(:question_subscription) }

    it "sets is_active to true by default" do
      expect(subscription.is_active).to be true
    end
  end
end
