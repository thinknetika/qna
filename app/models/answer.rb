class Answer < ApplicationRecord
  include Votable
  include Linkable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: "User"

  has_many_attached :files, dependent: :destroy

  validates :body, presence: true
end
