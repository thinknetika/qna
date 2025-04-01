class Answer < ApplicationRecord
  has_many_attached :files, dependent: :destroy

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  belongs_to :question
  belongs_to :author, class_name: "User"

  validates :body, presence: true
end
