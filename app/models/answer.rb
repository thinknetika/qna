class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: "User"

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files, dependent: :destroy

  validates :body, presence: true
end
