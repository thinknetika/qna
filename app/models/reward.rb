class Reward < ApplicationRecord
  has_one_attached :image

  has_many :user_rewards, dependent: :destroy
  has_many :user, through: :user_rewards

  belongs_to :question

  validates :title, presence: true
end
