require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question.id } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new answer in the database' do
        puts "question: #{question}; id: #{question.id}"
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does note save the question' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) } }
      end

      it 're-render new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :edit
    end
  end

  describe  'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assign the requested answer to @answer' do
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question.id, id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to question after answer update' do
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      before do
        @original_answer = answer
        patch :update, params: { question_id: question.id, id: answer, answer: attributes_for(:answer, :invalid_answer) }
      end

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq @original_answer.body
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to question' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question
    end
  end
end
