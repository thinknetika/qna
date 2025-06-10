class ProfilePolicy < ApplicationPolicy
  def me?
    user.present?
  end

  def index?
    user.present?
  end
end
