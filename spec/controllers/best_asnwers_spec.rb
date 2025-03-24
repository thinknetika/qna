require 'rails_helper'

RSpec.describe BestAnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer_1) { create(:answer, question: question, author: user) }
  let!(:answer_2) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(question.author) }

    context 'set new best answer' do
      before do
        post :create, params: { question_id: question.id, answer_id: answer_1.id }, as: :turbo_stream
      end

      it 'sets the best_answer_id for the question' do
        expect { question.reload }.to change(question, :best_answer_id).to(answer_1.id)
      end

      it 'renders best_answer' do
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"answer_#{answer_1.id}\">")
      end
    end

    context 'change best answer' do
      before do
        question.update(best_answer_id: answer_1.id)

        post :create, params: { question_id: question.id, answer_id: answer_2.id }, as: :turbo_stream
      end

      it 'changes the best_answer_id to the new answer' do


        expect { question.reload }.to change(question, :best_answer_id).from(answer_1.id).to(answer_2.id)
      end

      it 'renders turbo stream replace a new best answer' do
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"answer_#{answer_2.id}\">")
      end
    end
  end
end
