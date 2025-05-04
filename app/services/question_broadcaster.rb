class QuestionBroadcaster
  def self.broadcast(question, action)
    ActionCable.server.broadcast("questions_channel_authenticated",
                                 { question_html: render_question(question, true),
                                   action: action, question_id: question.id })

    ActionCable.server.broadcast("questions_channel_guest",
                                 { question_html: render_question(question, false),
                                   action: action, question_id: question.id })
  end

  private

  def self.render_question(question, authenticated)
    ApplicationController.renderer.render(
      partial: "questions/channels/question",
      locals: { question: question, authenticated: authenticated }
    )
  end
end
