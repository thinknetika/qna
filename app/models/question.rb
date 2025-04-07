class Question < ApplicationRecord
  has_many_attached :files, dependent: :destroy

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many :answers, dependent: :destroy

  has_many :user_rewards, dependent: :destroy

  has_one :reward, dependent: :destroy

  belongs_to :author, class_name: "User"
  belongs_to :best_answer, class_name: "Answer", optional: true

  validates :title, :body, presence: true
end
