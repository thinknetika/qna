class BestAnswerPolicy < ApplicationPolicy
  def create?
    user&.admin? || record.question.author == user
  end
end
