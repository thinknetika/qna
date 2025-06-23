require 'rails_helper'

RSpec.shared_examples 'unauthorized answer get requests' do
  it 'returns 401 status if there is no access_token' do
    get "#{request_url}", headers: headers
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    get "#{request_url}", headers: headers.merge('Authorization' => "Bearer 1234")
    expect(response.status).to eq 401
  end
end