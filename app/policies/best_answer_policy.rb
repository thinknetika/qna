class BestAnswerPolicy < ApplicationPolicy
  def create?
    user&.admin? || record.author == user
  end
end
