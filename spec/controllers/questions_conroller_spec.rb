require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 3) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    before { get :index }

    it 'get array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      get :show, params: { id: question }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question), format: :turbo_stream }
        }.to change(Question, :count).by(1)
      end

      it 'renders create.turbo_stream template' do
        post :create, params: { question: attributes_for(:question), format: :turbo_stream }
        expect(response).to render_template('questions/create')
      end
    end

    context 'with invalid attributes' do
      it 'does note save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid_question) } }
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { login(question.author) }

    context 'with valid attributes' do
      it 'assign the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid attributes' do
      before do
        @original_question = question
        patch :update, params: { id: question, question: attributes_for(:question, :invalid_question) }
      end

      it 'does not change question' do
        question.reload

        expect(question.title).to eq @original_question.title
        expect(question.body).to eq @original_question.body
      end

      it 're-render edit show' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(question.author) }

    let!(:question) { create(:question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
