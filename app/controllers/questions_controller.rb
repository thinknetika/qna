class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_view_source, only: %i[new edit update]
  before_action -> { authorize_user!(@question) }, only: %i[edit update destroy]

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
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      if @source_view == "index"
        redirect_to questions_path
      else
        redirect_to question_path(@question)
      end
    else
        render :edit
    end
  end

  def destroy
    @question.destroy

    redirect_to questions_path if params[:from] == "show"
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :from)
  end

  def set_view_source
    @source_view = params[:source_view] ? params[:source_view] : params[:question][:source_view]
  end
end
