class QuestionPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user.present?
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

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
