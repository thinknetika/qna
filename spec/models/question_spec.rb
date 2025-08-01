require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'Votable'
  it_behaves_like 'Linkable'

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

    context "question_subscriptions" do
      it { should have_many(:question_subscriptions).dependent(:destroy) }
    end

    context "subscriptions" do
      it { should have_many(:subscriptions).class_name('QuestionSubscription') }

      it "returns only active subscriptions" do
        question = create(:question)
        active_subscription = create(:question_subscription, question: question, is_active: true)
        inactive_subscription = create(:question_subscription, question: question, is_active: false)

        expect(question.subscriptions).to include(active_subscription)
        expect(question.subscriptions).not_to include(inactive_subscription)
      end
    end

    context "subscribers" do
      it { should have_many(:subscribers).through(:subscriptions).source(:user) }

      it "returns users who have active subscriptions" do
        question = create(:question)
        subscribed_user = create(:user)
        unsubscribed_user = create(:user)

        create(:question_subscription, question: question, user: subscribed_user, is_active: true)
        create(:question_subscription, question: question, user: unsubscribed_user, is_active: false)

        expect(question.subscribers).to include(subscribed_user)
        expect(question.subscribers).not_to include(unsubscribed_user)
      end
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

  describe "callbacks" do
    context "after_create" do
      let(:user) { create(:user) }

      it "automatically subscribes the author to the question" do
        question = build(:question, author: user)

        expect { question.save! }.to change { QuestionSubscription.count }.by(1)

        subscription = QuestionSubscription.last
        expect(subscription.user).to eq(user)
        expect(subscription.question).to eq(question)
        expect(subscription.is_active).to be true
      end

      it "creates subscription with correct attributes" do
        user = create(:user)
        question = create(:question, author: user)

        subscription = question.question_subscriptions.find_by(user: user)
        expect(subscription).to be_present
        expect(subscription.is_active).to be true
      end
    end
  end
end
