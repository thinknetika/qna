class AnswerCommentsBroadcaster
  def self.broadcast(channel, template, **params)
    Turbo::StreamsChannel.broadcast_render_to(
      channel,
      template:,
      **params
    )
  end
end
