require 'rails_helper'

RSpec.shared_examples 'authorized answer response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    %w[id body created_at updated_at].each do |attr|
      expect(answer_response[attr]).to eq answer.send(attr).as_json
    end
  end

  it 'contains user object' do
    expect(answer_response['author']['id']).to eq answer.author.id
  end
end