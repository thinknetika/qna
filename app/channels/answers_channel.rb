class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question_id = params[:question_id]

    if user
      stream_from "answers_question_#{question_id}_channel_authenticated"
    else
      stream_from "answers_question_#{question_id}_channel_unauthenticated"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
