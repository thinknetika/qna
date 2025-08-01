class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: %i[github google_oauth2 yandex]

  has_many :questions, foreign_key: "author_id", dependent: :destroy
  has_many :answers, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "author_id", dependent: :destroy

  has_many :user_rewards, dependent: :destroy
  has_many :rewards, through: :user_rewards

  has_many :votes, dependent: :destroy

  has_many :authorizations

  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :question_subscriptions, source: :question

  def owns?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_to?(question)
    question_subscriptions.active.exists?(question: question)
  end
end
