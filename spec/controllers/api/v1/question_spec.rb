require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let!(:questions_count) { 2 }
  let!(:questions) { create_list(:question, questions_count) }
  let(:question) { questions.first }
  let!(:answers_count) { 3 }
  let!(:answers) { create_list(:answer, answers_count, question: question) }

  describe 'GET /api/v1/questions' do
    let(:request_url) { "/api/v1/questions" }
    let(:question_response) { json['questions'].first }

    context 'unauthorized' do
      it_behaves_like 'unauthorized question get requests'
    end

    context 'authorized' do
      before { get request_url, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'authorized question response'

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'answers collection'
      end
    end
  end

  describe 'GET /api/v1/questions/question_id' do
    let(:request_url) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    context 'unauthorized' do
      it_behaves_like 'unauthorized question get requests'
    end

    context 'authorized' do
      before { get request_url, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it_behaves_like 'authorized question response'

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'answers collection'
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:valid_params) { { question: { title: 'New Question', body: 'Question body' } }.to_json }

    let(:request_url) { "/api/v1/questions/" }
    let(:question_response) { json['question'] }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "#{request_url}", params: valid_params, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "#{request_url}",params: valid_params, headers: headers.merge('Authorization' => "Bearer 1234")
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { post request_url, params: valid_params, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'creates a new question' do
        expect(Question.count).to eq questions_count + 1
      end
    end
  end

  describe 'PATCH /api/v1/questions/question_id' do
    let(:update_params) { { question: { title: 'Updated title', body: 'Updated body' } } }

    let(:request_url) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        patch "#{request_url}", params: update_params.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        patch "#{request_url}",params: update_params.to_json, headers: headers.merge('Authorization' => "Bearer 1234")
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { patch request_url, params: update_params.to_json, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'update question' do
        expect(json['question']['title']).to eq(update_params[:question][:title])
        expect(json['question']['body']).to eq(update_params[:question][:body])
      end
    end
  end

  describe 'DELETE /api/v1/questions/question_id' do
    let(:request_url) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete "#{request_url}", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete "#{request_url}", headers: headers.merge('Authorization' => "Bearer 1234")
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { delete request_url, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it 'returns 200 status' do
        expect(response).to be_no_content
      end

      it 'creates a new question' do
        expect(Question.count).to eq questions_count - 1
      end
    end
  end
end
