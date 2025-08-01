class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question

    subscribers = question.subscribers.where.not(id: answer.author_id)

    subscribers.find_each do |subscriber|
      AnswerNotificationMailer.new_answer(subscriber, answer).deliver_now
    end
  end
end
