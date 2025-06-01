module CommentsHelper
  def commentable_model_name(commentable)
    if commentable.is_a?(Question)
      commentable.model_name.singular
    elsif
      commentable.is_a?(Answer)
      "#{commentable.model_name.singular}_#{commentable.id}"
    end
  end
end
