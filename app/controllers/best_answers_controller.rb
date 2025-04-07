class BestAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer
  before_action :set_question
  before_action -> { authorize_user!(@question) }

  def create
    @previous_best_answer = @question.best_answer if @question.best_answer

    @question.best_answer_id = @answer.id
    @question.save!

    assign_reward_to_answer_author if @question.reward.present?
  end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end

  def set_question
    @question = @answer.question
  end

  def assign_reward_to_answer_author
    reward = @question.reward

    user_reward = UserReward.find_or_create_by(reward: reward, question: @question) do |u_r|
      u_r.user = @answer.author
    end

    unless user_reward.user.owns?(@answer)
      user_reward.update!(user: @answer.author)
    end
  end
end
