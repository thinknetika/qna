class AnswerBroadcaster
  def self.broadcast(answer, action)
    question = answer.question
    question_id = question.id

    ActionCable.server.broadcast("answers_question_#{question_id}_channel_authenticated",
                                 { answer_html: render_answer(answer, question, true),
                                   action: action, answer_id: answer.id })

    ActionCable.server.broadcast("answers_question_#{question_id}_channel_unauthenticated",
                                 { answer_html: render_answer(answer, question, false),
                                   action: action, answer_id: answer.id })
  end

  private

  def self.render_answer(answer, question, authenticated)
    ApplicationController.renderer.render(
      partial: "answers/channels/answer",
      locals: { answer: answer, question: question, authenticated: authenticated }
    )
  end
end

