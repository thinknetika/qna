class QuestionsController < ApplicationController
  include QuestionsHelper

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show edit update destroy destroy_file]
  before_action -> { authorize_user!(@question) }, only: %i[edit update destroy destroy_file]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      turbo_stream
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy

    if show_view(@question)
      redirect_to (questions_path), status: :see_other
    else
      turbo_stream
    end
  end

  def destroy_file
    @file = @question&.files.find_by(id: params[:file_id])
    @file.purge

    turbo_stream
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def authorize_question!
    unless current_user&.owns?(@question)
      redirect_to questions_path(@question), alert: "You are not authorized to perform this action.", status: :see_other
    end
  end
end
