class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :authorize_question!, only: %i[update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "Your question successfully created", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: "Your question was successfully deleted", status: :see_other
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def authorize_question!
    unless current_user&.owns?(@question)
      redirect_to questions_path(@question), alert: "You are not authorized to perform this action.", status: :see_other
    end
  end
end
