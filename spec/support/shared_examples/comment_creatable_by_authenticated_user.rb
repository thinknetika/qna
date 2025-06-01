require 'rails_helper'

RSpec.shared_examples 'comment creatable by authenticated user' do
  it 'grants access to any logged in user' do
    expect(subject).to permit(user, Comment.new)
  end

  it 'denied access if guest' do
    expect(subject).not_to permit(nil, comment)
  end
end
