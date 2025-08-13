require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    before { login(user) }

    context 'with valid search query and category' do
      let(:query) { 'test query' }
      let(:category) { 'questions' }
      let(:questions) { [create(:question, title: 'test query')] }

      before do
        allow(SearchService).to receive(:search).with(query, category).and_return(questions: questions)
        get :index, params: { query: query, category: category }, as: :turbo_stream
      end

      it 'calls SearchService with correct parameters' do
        expect(SearchService).to have_received(:search).with(query, category)
      end

      it 'renders the turbo_stream template' do
        expect(response.media_type).to eq Mime[:turbo_stream]
      end

      it 'responds with success' do
        expect(response).to be_successful
      end

      it 'renders turbo stream replace with search results' do
        expect(response.body).to include("<turbo-stream")
        expect(response.body).to include("target=\"search-results\"")
        expect(response.body).to include("test query")
      end
    end

    context 'without a search query' do
      before do
        allow(SearchService).to receive(:search).and_return({})
        get :index, as: :turbo_stream
      end

      it 'responds with success' do
        expect(response).to be_successful
      end
    end
  end
end
