module ApplicationHelper
  def author_of?(resource)
    user_signed_in? && current_user.owns?(resource)
  end
end
