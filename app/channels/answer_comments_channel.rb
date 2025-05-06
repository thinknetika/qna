class AnswerCommentsChannel < ApplicationCable::Channel
  def subscribed
    answer_id = params[:answer_id]

    if user
      stream_from "answer_#{answer_id}_comments_channel_authenticated"
    else
      stream_from "answer_#{answer_id}_comments_channel_unauthenticated"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
