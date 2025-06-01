require 'rails_helper'

RSpec.shared_examples 'question accessible by admin author' do
  it 'grants access if user is admin' do
    expect(subject).to permit(admin, question)
  end

  it 'grants access if user is author' do
    expect(subject).to permit(user, question)
  end

  it 'denied access if user is not author' do
    expect(subject).not_to permit(User.new, question)
  end

  it 'denied access if guest' do
    expect(subject).not_to permit(nil, question)
  end
end
