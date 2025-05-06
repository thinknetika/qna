class QuestionCommentsBroadcaster
  def self.broadcast(comment, action)
    question_id = comment.commentable.id

    ActionCable.server.broadcast("question_#{question_id}_comments_channel_authenticated",
                                 { comment_html: render_comment(comment, true),
                                   action: action, comment_id: comment.id })

    ActionCable.server.broadcast("question_#{question_id}_comments_channel_unauthenticated",
                                 { comment_html: render_comment(comment, false),
                                   action: action, comment_id: comment.id })
  end

  private

  def self.render_comment(comment, authenticated)
    ApplicationController.renderer.render(
      partial: "comments/channels/comment",
      locals: { comment: comment, authenticated: authenticated }
    )
  end
end
