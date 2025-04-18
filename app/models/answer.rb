class Answer < ApplicationRecord
  include Votable
  include Linkable

  belongs_to :question
  belongs_to :author, class_name: "User"

  has_many_attached :files, dependent: :destroy

  validates :body, presence: true
end
