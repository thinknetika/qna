class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  def authorize_user!(resource)
    unless current_user&.owns?(resource)
      redirect_to root_path, alert: "You are not authorized to perform this action.", status: :see_other
    end
  end
end
