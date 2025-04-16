require 'rails_helper'

RSpec.shared_examples 'Votable' do
  subject { FactoryBot.create(described_class.to_s.underscore.to_sym) }

  context "votes" do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#rating' do
    it 'returns 0 if no votes' do
      expect(subject.rating).to eq(0)
    end

    it 'calculates the correct rating' do
      create(:vote, votable: subject, user: subject.author, value: 1)
      expect(subject.rating).to eq(1)

      create(:vote, votable: subject, user: create(:user), value: -1)
      expect(subject.rating).to eq(0)
    end
  end

  describe '#vote_by' do
    it 'returns the vote for a given user' do
      vote = create(:vote, votable: subject, user: subject.author, value: 1)
      expect(subject.vote_by(subject.author)).to eq(vote)
    end

    it 'returns nil if the user has not voted' do
      expect(subject.vote_by(subject.author)).to be_nil
    end
  end
end

