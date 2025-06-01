require 'rails_helper'

RSpec.shared_examples 'answer accessible by admin author' do
  it 'grants access if user is admin' do
    expect(subject).to permit(admin, answer)
  end

  it 'grants access if user is author' do
    expect(subject).to permit(user, answer)
  end

  it 'denied access if user is not author' do
    expect(subject).not_to permit(User.new, answer)
  end

  it 'denied access if guest' do
    expect(subject).not_to permit(nil, answer)
  end
end
