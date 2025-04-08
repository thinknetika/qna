class UserReward < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  belongs_to :question

  validates :reward_id, uniqueness: { scope: [ :question_id ] }

  scope :for_user, ->(user) { where(user: user) }
end
