require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question.id }, as: :turbo_stream }

    # it 'assigns a new Answer to @answer' do
    #   expect(assigns(:answer)).to be_a_new(Answer)
    # end

    it 'returns ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'render new view' do
      expect(response.body).to include('<turbo-stream action="replace" target="new_answer">')
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :turbo_stream } }.to change(Answer, :count).by(1)
      end

      it 'returns ok status' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) },
             as: :turbo_stream

        expect(response).to have_http_status(:ok)
      end

      it 'responds with success and appends the answer to the answers list' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) },
             as: :turbo_stream

        expect(response.body).to include('<turbo-stream action="append" target="answers">')
      end
    end

    context 'with invalid attributes' do
      it 'does note save the question' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
                      as: :turbo_stream
        }
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
             as: :turbo_stream

        expect(response).to have_http_status(422)
      end

      it 'renders a turbo stream to replace the new answer form with errors on invalid submission' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
             as: :turbo_stream

        expect(response.body).to include('<turbo-stream action="replace" target="new_answer">')
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: answer }, as: :turbo_stream }

    # it 'assigns the requested answer to @answer' do
    #   expect(assigns(:answer)).to eq answer
    # end

    it 'responds with success' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders a turbo stream to replace the answer' do
      expect(response.body).to include("<turbo-stream action=\"replace\" target=\"answer_#{answer.id}\">")
    end
  end

  describe 'PATCH #update' do
    before { login(answer.author) }

    context 'with valid attributes' do
      # it 'assign the requested answer to @answer' do
      #   patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) }
      #   expect(assigns(:answer)).to eq answer
      # end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer, answer: { body: 'new body' } },
              as: :turbo_stream

        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'responds with success' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a turbo stream to replace the answer' do
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) },
              as: :turbo_stream

        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"answer_#{answer.id}\">")
      end
    end

    context 'with invalid attributes' do
      before { login(answer.author) }

      before do
        @original_answer = answer
        patch :update,
              params: { question_id: question.id, id: answer, answer: attributes_for(:answer, :invalid_answer) },
              as: :turbo_stream
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq @original_answer.body
      end

      it 'returns unprocessable_entity status' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
             as: :turbo_stream

        expect(response).to have_http_status(422)
      end

      it 'renders a turbo stream to replace the answer form with errors on invalid submission' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
             as: :turbo_stream

        expect(response.body).to include('<turbo-stream action="replace" target="new_answer">')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(answer.author) }

    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question.id, id: answer }, as: :turbo_stream }.
        to change(Answer, :count).by(-1)
    end

    it 'redirect to question' do
      delete :destroy, params: { id: answer }, as: :turbo_stream

      puts response.body

      expect(response.body).to include("<turbo-stream action=\"remove\" target=\"answer_#{answer.id}\">")
    end
  end
end
