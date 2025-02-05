class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :set_question_from_answer, only: %i[update destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy

    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_question_from_answer
    @question = @answer.question
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
