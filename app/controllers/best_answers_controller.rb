class BestAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer
  before_action :set_question
  before_action -> { authorize_user!(@question) }

  def create
    @previous_best_answer = @question.best_answer if @question.best_answer

    @question.best_answer_id = @answer.id
    @question.save!
  end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_question
    @question = @answer.question
  end
end
