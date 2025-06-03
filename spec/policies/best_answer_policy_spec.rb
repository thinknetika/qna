require 'rails_helper'

RSpec.describe BestAnswerPolicy, type: :policy do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question) }

  subject { described_class }

  context 'when user is admin' do
    permissions :create? do
      it 'grants access' do
        expect(subject).to permit(admin, answer)
      end
    end
  end

  context 'when user is the author of the question' do
    permissions :create? do
      it 'grants access' do
        expect(subject).to permit(author, answer)
      end
    end
  end

  context 'when user is not the author of the question' do
    permissions :create? do
      it 'denies access' do
        expect(subject).not_to permit(user, answer)
      end
    end
  end

  context 'when user is a guest' do
    permissions :create? do
      it 'denies access' do
        expect(subject).not_to permit(nil, answer)
      end
    end
  end
end
