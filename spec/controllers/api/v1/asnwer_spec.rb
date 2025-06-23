require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  let(:access_token) { create(:access_token) }
  let!(:questions_count) { 2 }
  let!(:questions) { create_list(:question, questions_count) }
  let(:question) { questions.first }
  let!(:answers_count) { 3 }
  let!(:answers) { create_list(:answer, answers_count, question: question) }
  let!(:answer) { answers.first }

  describe 'GET /api/v1/questions/question_id/answers' do
    let(:request_url) { "/api/v1/questions/#{question.id}/answers" }
    let(:answer_response) { json['answers'].first }

    context 'unauthorized' do
      it_behaves_like 'unauthorized answer get requests'
    end

    context 'authorized' do
      before { get request_url, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it 'returns list of questions' do
        expect(json['answers'].size).to eq answer_count
      end

      it_behaves_like 'authorized answer response'
    end
  end

  describe 'GET /api/v1/answers/answer_id' do
    let(:request_url) { "/api/v1/answers/#{answer.id}" }
    let(:answer_response) { json['answer'] }

    context 'unauthorized' do
      it_behaves_like 'unauthorized answer get requests'
    end

    context 'authorized' do
      before { get request_url, headers: headers.merge('Authorization' => "Bearer #{access_token.token}") }

      it_behaves_like 'authorized answer response'
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let(:valid_params) { { answer: { body: 'New answer' } }.to_json }

    let(:request_url) { "/api/v1/questions/#{question.id}/answers" }
    let(:answer_response) { json['answer'] }

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

      it 'create a new answer' do
        expect(Answer.count).to eq answers_count + 1
      end
    end
  end

  describe 'PATCH /api/v1/answers/answer_id' do
    let(:update_params) { { answer: { body: 'Updated answer' } } }

    let(:request_url) { "/api/v1/answers/#{answer.id}" }
    let(:answer_response) { json['answer'] }

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

      it 'update answer' do
        expect(json['answer']['body']).to eq(update_params[:answer][:body])
      end
    end
  end

  describe 'DELETE /api/v1/answers/answer.id' do
    let(:request_url) { "/api/v1/answers/#{answer.id}" }

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

      it 'delete answer' do
        expect(Answer.count).to eq answers_count - 1
      end
    end
  end
end
