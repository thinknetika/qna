class AnswerPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user
  end

  def edit?
    update?
  end

  def update?
    user&.admin? || user == record.author
  end

  def destroy?
    user&.admin? || user == record.author
  end
end
