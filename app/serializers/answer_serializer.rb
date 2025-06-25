class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :created_at, :updated_at

  has_many :comments
  has_many :links
  has_many :files

  belongs_to :author, class_name: "User"
end
