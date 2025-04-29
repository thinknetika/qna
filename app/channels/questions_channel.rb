class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    if user
      stream_from "questions_channel_authenticated"
    else
      stream_from "questions_channel_guest"
    end
  end

  def unsubscribed; end
end
