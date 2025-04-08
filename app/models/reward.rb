class Reward < ApplicationRecord
  belongs_to :question

  has_many :user_rewards, dependent: :destroy
  has_many :user, through: :user_rewards

  has_one_attached :image

  validates :title, presence: true
end
