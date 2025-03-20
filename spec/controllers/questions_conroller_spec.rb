require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3, author: user) }
  let!(:question) { create(:question, author: user) }

  describe 'GET #index' do
    before { get :index }

    # it 'get array of all questions' do
    #   expect(assigns(:questions)).to match_array(questions)
    # end

    # it 'render index view' do
    #   expect(response).to render_template :index
    # end

    it 'returns ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'render index view tags' do
      expect(response.body).to include('<turbo-frame id="new_question">')
      expect(response.body).to include('</turbo-frame><div id="questions">')
    end

    it 'render list of questions' do
      questions.each do |question|
        expect(response.body).to include("<turbo-frame id=\"question_#{question.id}\">")
      end
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: question } }

    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to eq question
    # end

    # it 'render show view' do
    #   expect(response).to render_template :show
    # end

    it 'returns ok status' do
      expect(response).to have_http_status(:ok)
    end

    it 'render question' do
      expect(response.body).to include("<turbo-frame id=\"question_#{question.id}\">")
      expect(response.body).to include(question.title)
      expect(response.body).to include(question.body)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, as: :turbo_stream }

    # it 'assigns a new Question to @question' do
    #   expect(assigns(:question)).to be_a_new(Question)
    # end

    it 'render new view' do
      expect(response.body).to include('turbo-stream action="replace" target="new_question">')
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question) }, as: :turbo_stream
        }.to change(Question, :count).by(1)
      end

      it 'renders new question link' do
        post :create, params: { question: attributes_for(:question) }, as: :turbo_stream

        expect(response.body).to include('<turbo-stream action="update" target="new_question">')
      end

      it 'renders created question' do
        post :create, params: { question: attributes_for(:question) }, as: :turbo_stream

        expect(response.body).to include('<turbo-stream action="prepend" target="questions">')
      end
    end

    context 'with invalid attributes' do
      it 'does note save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid_question) }, as: :turbo_stream }
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid_question) }, as: :turbo_stream

        expect(response.body).to include('turbo-stream action="replace" target="new_question">')
      end

      it 'expect errors' do
        post :create, params: { question: attributes_for(:question, :invalid_question) }, as: :turbo_stream

        expect(response.body).to include('<div data-question-form-target="errors">')
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to eq question
    # end

    context 'from index view' do
      before { get :edit, params: { id: question, source_view: 'index' }, as: :turbo_stream }

      it 'expect question' do
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
      end

      it 'expect form' do
        expect(response.body).to include("<form action=\"/questions/4\"")
      end
    end

    context 'from show view' do
      before { get :edit, params: { id: question, source_view: 'show' }, as: :turbo_stream }

      it 'expect question' do
        expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
      end

      it 'expect form' do
        expect(response.body).to include("<form action=\"/questions/#{question.id}\"")
      end
    end
  end

  describe 'PATCH #update' do
    before { login(question.author) }

    context 'from index view' do
      context 'with valid attributes' do
        # it 'assign the requested question to @question' do
        #   patch :update, params: { id: question, question: attributes_for(:question) }
        #   expect(assigns(:question)).to eq question
        # end

        it 'changes question attributes' do
          patch :update,
                params: { id: question, question: { title: 'new title', body: 'new body' },
                          source_view: 'index' },
                as: :turbo_stream

          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'response updated question' do
          patch :update, params: { id: question, question: attributes_for(:question), source_view: 'index' }, as: :turbo_stream

          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
        end
      end

      context 'with invalid attributes' do
        before do
          @original_question = question
          patch :update,
                params: { id: question, question: attributes_for(:question, :invalid_question), source_view: 'index' },
                as: :turbo_stream
        end

        it 'does not change question' do
          question.reload

          expect(question.title).to eq @original_question.title
          expect(question.body).to eq @original_question.body
        end

        it 'expect question' do
          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
        end

        it 'expect form' do
          expect(response.body).to include("<form action=\"/questions/#{question.id}\"")
        end

        it 'expect errors' do
          expect(response.body).to include('<div data-question-form-target="errors">')
        end
      end
    end

    context 'from show view' do
      context 'with valid attributes' do
        # it 'assign the requested question to @question' do
        #   patch :update, params: { id: question, question: attributes_for(:question) }
        #   expect(assigns(:question)).to eq question
        # end

        it 'changes question attributes' do
          patch :update,
                params: { id: question, question: { title: 'new title', body: 'new body' },
                          source_view: 'show' },
                as: :turbo_stream

          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'response updated question' do
          patch :update, params: { id: question, question: attributes_for(:question), source_view: 'show' }, as: :turbo_stream

          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
        end
      end

      context 'with invalid attributes' do
        before do
          @original_question = question
          patch :update,
                params: { id: question, question: attributes_for(:question, :invalid_question), source_view: 'show' },
                as: :turbo_stream
        end

        it 'does not change question' do
          question.reload

          expect(question.title).to eq @original_question.title
          expect(question.body).to eq @original_question.body
        end

        it 'expect question' do
          expect(response.body).to include("<turbo-stream action=\"replace\" target=\"question_#{question.id}\">")
        end

        it 'expect form' do
          expect(response.body).to include("<form action=\"/questions/#{question.id}\"")
        end

        it 'expect errors' do
          expect(response.body).to include('<div data-question-form-target="errors">')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(question.author) }

    let!(:question) { create(:question) }

    context 'from index view' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question, source_view: 'index' }, as: :turbo_stream }.to change(Question, :count).by(-1)
      end

      it 'expect turbo with remove question' do
        delete :destroy, params: { id: question, source_view: 'index' }, as: :turbo_stream

        expect(response.body).to include("<turbo-stream action=\"remove\" target=\"question_#{question.id}\"></turbo-stream>")
        puts response.body
      end
    end

    context 'from show view' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question, source_view: 'show' }, as: :turbo_stream }.to change(Question, :count).by(-1)
      end

      it 'redirect to index path' do
        delete :destroy, params: { id: question, source_view: 'show' }

        expect(response).to redirect_to(questions_path)
      end
    end
  end
end
