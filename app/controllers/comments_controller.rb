class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[new create]
  before_action :set_comment, only: %i[edit update destroy]
  before_action -> { authorize_user!(@comment) }, only: %i[edit update destroy]

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      commentable_model_name = @comment.commentable.model_name.singular
      service_class_name = "#{commentable_model_name.classify}CommentsBroadcaster"

      service_class = service_class_name.constantize
      service_class.broadcast(@comment, "create")

      turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      QuestionCommentsBroadcaster.broadcast(@comment, "update")

      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    QuestionCommentsBroadcaster.broadcast(@comment, "destroy")

    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
