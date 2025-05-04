class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[new create]
  before_action :set_comment, only: %i[edit update destroy]
  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user

    if @comment.save
      turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
