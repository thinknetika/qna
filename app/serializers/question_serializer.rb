class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :short_title, :created_at, :updated_at

  has_many :answers
  has_many :links
  has_many :comments
  has_one :reward

  belongs_to :author, class_name: "User"

  def short_title
    object.title.truncate(7)
  end
end
