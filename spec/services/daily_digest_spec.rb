require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:users) {create_list(:user, 3)}
  let!(:questions) { create_list(:question, 5, :without_author, author: users.sample) }
  let!(:old_question) { create(:question, :without_author, author: users.sample, created_at: 2.days.ago) }

  it 'sends daily digest to all users with recent questions' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original
    end

    subject.send_digest
  end

  it 'does not include old questions in the digest' do
    users.each do |user|
      expect(DailyDigestMailer).not_to receive(:digest).with(user, [old_question]).and_call_original # Проверка, что старый вопрос не попал в дайджест
    end

    subject.send_digest
  end
end
