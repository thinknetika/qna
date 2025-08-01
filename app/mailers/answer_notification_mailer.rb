class AnswerNotificationMailer < ApplicationMailer
  def new_answer(user, answer)
    @user = user
    @answer = answer
    @question = answer.question

    mail(
      to: user.email,
      subject: "Новый ответ на вопрос: #{@question.title}"
    )
  end
end
