class Question < ApplicationRecord
  include Votable
  include Linkable
  include Commentable

  belongs_to :author, class_name: "User"
  belongs_to :best_answer, class_name: "Answer", optional: true

  has_many :answers, dependent: :destroy
  has_many :user_rewards, dependent: :destroy

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files, dependent: :destroy

  has_many :question_subscriptions, dependent: :destroy
  has_many :subscriptions, -> { active }, class_name: 'QuestionSubscription'
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true

  after_create :subscribe_author

  private

  def subscribe_author
    question_subscriptions.create!(user: author, is_active: true)
  end
end
