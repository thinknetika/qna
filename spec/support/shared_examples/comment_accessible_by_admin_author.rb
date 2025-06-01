require 'rails_helper'

RSpec.shared_examples 'comment accessible by admin author' do
  it 'grants access if user is admin' do
    expect(subject).to permit(admin, comment)
  end

  it 'grants access if user is author' do
    expect(subject).to permit(user, comment)
  end

  it 'denied access if user is not author' do
    expect(subject).not_to permit(User.new, comment)
  end

  it 'denied access if guest' do
    expect(subject).not_to permit(nil, comment)
  end
end
