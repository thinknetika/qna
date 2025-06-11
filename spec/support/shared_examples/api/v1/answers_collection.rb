require 'rails_helper'

RSpec.shared_examples 'answers collection' do
  it 'returns list of answers' do
    expect(question_response['answers'].size).to eq answers_count
  end

  it 'returns all public fields' do
    %w[id body author_id created_at updated_at].each do |attr|
      expect(answer_response[attr]).to eq answer.send(attr).as_json
    end
  end
end