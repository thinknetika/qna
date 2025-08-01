class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_subscription, only: [:destroy]

  def create
    @subscription = @question.question_subscriptions.build(user: current_user)

    if @subscription.save
      turbo_stream
    else
      flash[:alert] = 'Вы уже подписаны на этот вопрос'

      turbo_stream
    end
  end

  def destroy
    @subscription.destroy
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = current_user.question_subscriptions.find_by!(question: @question)
  end
end
