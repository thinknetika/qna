class Answer < ApplicationRecord
  has_many_attached :files, dependent: :destroy

  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true
end
