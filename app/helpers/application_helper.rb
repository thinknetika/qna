module ApplicationHelper
  def author_of?(resource)
    current_user&.owns?(resource)
  end
end
