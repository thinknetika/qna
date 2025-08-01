class QuestionSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user_id, uniqueness: { scope: :question_id }

  scope :active, -> { where(is_active: true) }
end
