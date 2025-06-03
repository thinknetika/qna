class BestAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer
  before_action :set_question

  def create
    authorize @question, :create?, policy_class: BestAnswerPolicy

    @previous_best_answer = @question.best_answer if @question.best_answer

    @question.best_answer_id = @answer.id
    @question.save!

    assign_reward if @question.reward.present?
  end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_question
    @question = @answer.question
  end

  def assign_reward
    return unless @question.reward.present?

    reward = @question.reward

    user_reward = UserReward.find_or_create_by(reward: reward, question: @question)

    user_reward.update!(user: @answer.author)
  end
end
