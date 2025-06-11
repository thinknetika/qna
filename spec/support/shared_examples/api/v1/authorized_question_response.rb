require 'rails_helper'

RSpec.shared_examples 'authorized question response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    %w[id title body created_at updated_at].each do |attr|
      expect(question_response[attr]).to eq questions.first.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(question_response['author']['id']).to eq question.author.id
  end

  it 'contains short title' do
    expect(question_response['short_title']).to eq question.title.truncate(7)
  end
end