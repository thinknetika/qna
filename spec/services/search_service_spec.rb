require 'rails_helper'

RSpec.describe SearchService do
  let(:query) { 'test query' }

  let!(:question) { create(:question, title: 'test query question', body: 'some body') }
  let!(:answer) { create(:answer, body: 'test query answer') }
  let!(:user) { create(:user, email: 'testquery@example.com') }
  let!(:comment) { create(:comment, body: 'test query comment', commentable: question) }

  describe '.search' do
    context 'when category is "questions"' do
      let(:category) { 'questions' }
      subject { SearchService.search(query, category) }

      before do
        allow(Question).to receive(:search).with(query).and_return([question])
      end

      it 'calls Question.search with query' do
        subject
        expect(Question).to have_received(:search).with(query)
      end

      it 'returns hash with questions key' do
        expect(subject).to have_key(:questions)
      end

      it 'returns questions in results' do
        expect(subject[:questions]).to eq([question])
      end

      it 'does not include other categories' do
        expect(subject).to_not have_key(:answers)
        expect(subject).to_not have_key(:users)
        expect(subject).to_not have_key(:comments)
      end
    end

    context 'when category is "answers"' do
      let(:category) { 'answers' }
      subject { SearchService.search(query, category) }

      before do
        allow(Answer).to receive(:search).with(query).and_return([answer])
      end

      it 'calls Answer.search with query' do
        subject
        expect(Answer).to have_received(:search).with(query)
      end

      it 'returns hash with answers key' do
        expect(subject).to have_key(:answers)
      end

      it 'returns answers in results' do
        expect(subject[:answers]).to eq([answer])
      end

      it 'does not include other categories' do
        expect(subject).to_not have_key(:questions)
        expect(subject).to_not have_key(:users)
        expect(subject).to_not have_key(:comments)
      end
    end

    context 'when category is "users"' do
      let(:category) { 'users' }
      subject { SearchService.search(query, category) }

      before do
        allow(User).to receive(:search).with(query).and_return([user])
      end

      it 'calls User.search with query' do
        subject
        expect(User).to have_received(:search).with(query)
      end

      it 'returns hash with users key' do
        expect(subject).to have_key(:users)
      end

      it 'returns users in results' do
        expect(subject[:users]).to eq([user])
      end

      it 'does not include other categories' do
        expect(subject).to_not have_key(:questions)
        expect(subject).to_not have_key(:answers)
        expect(subject).to_not have_key(:comments)
      end
    end

    context 'when category is "comments"' do
      let(:category) { 'comments' }
      subject { SearchService.search(query, category) }

      before do
        allow(Comment).to receive(:search).with(query).and_return([comment])
      end

      it 'calls Comment.search with query' do
        subject
        expect(Comment).to have_received(:search).with(query)
      end

      it 'returns hash with comments key' do
        expect(subject).to have_key(:comments)
      end

      it 'returns comments in results' do
        expect(subject[:comments]).to eq([comment])
      end

      it 'does not include other categories' do
        expect(subject).to_not have_key(:questions)
        expect(subject).to_not have_key(:answers)
        expect(subject).to_not have_key(:users)
      end
    end

    context 'when category is nil or unknown' do
      let(:category) { nil }
      subject { SearchService.search(query, category) }

      before do
        allow(Question).to receive(:search).with(query).and_return([question])
        allow(Answer).to receive(:search).with(query).and_return([answer])
        allow(User).to receive(:search).with(query).and_return([user])
        allow(Comment).to receive(:search).with(query).and_return([comment])
      end

      it 'calls search on all models' do
        subject
        expect(Question).to have_received(:search).with(query)
        expect(Answer).to have_received(:search).with(query)
        expect(User).to have_received(:search).with(query)
        expect(Comment).to have_received(:search).with(query)
      end

      it 'returns hash with all categories' do
        result = subject
        expect(result).to have_key(:questions)
        expect(result).to have_key(:answers)
        expect(result).to have_key(:users)
        expect(result).to have_key(:comments)
      end

      it 'returns results for all categories' do
        result = subject
        expect(result[:questions]).to eq([question])
        expect(result[:answers]).to eq([answer])
        expect(result[:users]).to eq([user])
        expect(result[:comments]).to eq([comment])
      end
    end

    context 'when category is unknown string' do
      let(:category) { 'unknown_category' }
      subject { SearchService.search(query, category) }

      before do
        allow(Question).to receive(:search).with(query).and_return([question])
        allow(Answer).to receive(:search).with(query).and_return([answer])
        allow(User).to receive(:search).with(query).and_return([user])
        allow(Comment).to receive(:search).with(query).and_return([comment])
      end

      it 'falls back to searching all categories' do
        subject
        expect(Question).to have_received(:search).with(query)
        expect(Answer).to have_received(:search).with(query)
        expect(User).to have_received(:search).with(query)
        expect(Comment).to have_received(:search).with(query)
      end

      it 'returns results for all categories' do
        result = subject
        expect(result[:questions]).to eq([question])
        expect(result[:answers]).to eq([answer])
        expect(result[:users]).to eq([user])
        expect(result[:comments]).to eq([comment])
      end
    end

    context 'when query is empty' do
      let(:query) { '' }
      let(:category) { 'questions' }
      subject { SearchService.search(query, category) }

      before do
        allow(Question).to receive(:search).with(query).and_return([])
      end

      it 'still calls search method' do
        subject
        expect(Question).to have_received(:search).with(query)
      end

      it 'returns empty results' do
        expect(subject[:questions]).to eq([])
      end
    end

    context 'when no results found' do
      let(:query) { 'nonexistent query' }
      let(:category) { 'questions' }
      subject { SearchService.search(query, category) }

      before do
        allow(Question).to receive(:search).with(query).and_return([])
      end

      it 'returns empty array for the category' do
        expect(subject[:questions]).to eq([])
      end

      it 'returns hash with the expected structure' do
        expect(subject).to be_a(Hash)
        expect(subject).to have_key(:questions)
      end
    end
  end
end
