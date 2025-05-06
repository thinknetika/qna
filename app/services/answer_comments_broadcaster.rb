class AnswerCommentsBroadcaster
  def self.broadcast(comment, action)
    answer_id = comment.commentable.id

    ActionCable.server.broadcast("answer_#{answer_id}_comments_channel_authenticated",
                                 { comment_html: render_comment(comment, true),
                                   action: action, comment_id: comment.id, answer_id: answer_id })

    ActionCable.server.broadcast("answer_#{answer_id}_comments_channel_unauthenticated",
                                 { comment_html: render_comment(comment, false),
                                   action: action, comment_id: comment.id, answer_id: answer_id })
  end

  private

  def self.render_comment(comment, authenticated)
    ApplicationController.renderer.render(
      partial: "comments/channels/comment",
      locals: { comment: comment, authenticated: authenticated }
    )
  end
end
