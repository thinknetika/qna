class QuestionCommentsChannel < ApplicationCable::Channel
  def subscribed
    question_id = params[:question_id]

    if user
      stream_from "question_#{question_id}_comments_channel_authenticated"
    else
      stream_from "question_#{question_id}_comments_channel_unauthenticated"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
