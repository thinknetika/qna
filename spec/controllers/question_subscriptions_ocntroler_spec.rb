require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: other_user) }

  describe 'POST #create' do
    context 'when user is authenticated' do
      before { login(user) }

      context 'with valid subscription' do
        it 'associates subscription with correct user and question' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          subscription = QuestionSubscription.last
          expect(subscription.user).to eq(user)
          expect(subscription.question).to eq(question)
          expect(subscription.is_active).to be true
        end

        it 'returns ok status' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          expect(response).to have_http_status(:ok)
        end

        it 'renders turbo stream response' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        end
      end

      context 'when user already subscribed' do
        before { create(:question_subscription, user: user, question: question) }

        it 'does not create duplicate subscription' do
          expect {
            post :create, params: { question_id: question.id }, as: :turbo_stream
          }.not_to change(QuestionSubscription, :count)
        end

        it 'sets flash alert message' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          expect(flash[:alert]).to eq('Вы уже подписаны на этот вопрос')
        end

        it 'returns ok status' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          expect(response).to have_http_status(:ok)
        end

        it 'renders turbo stream response' do
          post :create, params: { question_id: question.id }, as: :turbo_stream

          expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        end
      end

      context 'with invalid question_id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            post :create, params: { question_id: 999999 }, as: :turbo_stream
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        post :create, params: { question_id: question.id }, as: :turbo_stream

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is authenticated' do
      before { login(user) }

      context 'when subscription exists' do
        let!(:subscription) { create(:question_subscription, user: user, question: question, is_active: true) }

        it 'returns ok status' do
          delete :destroy, params: { question_id: question.id }, as: :turbo_stream

          expect(response).to have_http_status(:ok)
        end

        it 'renders turbo stream response' do
          delete :destroy, params: { question_id: question.id }, as: :turbo_stream

          expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        end
      end

      context 'when subscription does not exist' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            delete :destroy, params: { question_id: question.id }, as: :turbo_stream
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'with invalid question_id' do
        it 'raises ActiveRecord::RecordNotFound' do
          expect {
            delete :destroy, params: { question_id: 999999 }, as: :turbo_stream
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        delete :destroy, params: { question_id: question.id }, as: :turbo_stream

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
