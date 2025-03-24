module AnswersHelper
  def answer_form_url(answer, question = nil)
    if answer.new_record?
      question_answers_path(question)
    else
      answer_path(answer)
    end
  end
end
