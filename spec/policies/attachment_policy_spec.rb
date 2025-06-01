require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentPolicy, type: :policy do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:attachment) { question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain'); question.files.first.blob.attachments.first } # Получаем attachment

  subject { described_class }

  permissions :destroy? do
    it "grants access if user is admin" do
      expect(subject).to permit(admin, attachment)
    end

    it "grants access if the user is the author of the question" do
      expect(subject).to permit(author, attachment)
    end

    it "denies access if the user is not the author of the question" do
      expect(subject).not_to permit(user, attachment)
    end

    it "denies access if the user is quest" do
      expect(subject).not_to permit(nil, attachment)
    end
  end
end
