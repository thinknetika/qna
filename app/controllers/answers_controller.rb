class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[edit update destroy]
  before_action :set_question_from_answer, only: %i[update destroy]
  before_action :authorize_answer!, only: %i[update destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params).tap { |answer| answer.author = current_user }

    respond_to do |format|
      if @answer.save
        format.turbo_stream { render turbo_stream: turbo_stream.append("answers", partial: "answers/answer", locals: { answer: @answer }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("answer_form", partial: "answers/form", locals: { question: @question, answer: @answer }), status: :unprocessable_entity }
      end
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

    redirect_to @question, notice: "Your answer was successfully deleted", status: :see_other
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

  def authorize_answer!
    unless current_user&.owns?(@answer)
      redirect_to answer_path(@answer), alert: "You are not authorized to perform this action.", status: :see_other
    end
  end
end
