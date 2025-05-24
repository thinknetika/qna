class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[github google_oauth2 yandex]

  def github
    handle_omniauth("github")
  end

  def google_oauth2
    handle_omniauth("google_oauth2")
  end

  def yandex
    user, password = User.find_for_oauth(request.env["omniauth.auth"])

    if user&.persisted?
      sign_in user, event: :authentication
      set_flash_message(:notice, :success, kind: "Yandex") if is_navigational_format?

      if user.email.include?('@example.com')
        session[:temporary_password] = password

        redirect_to edit_user_registration_path, status: :see_other
      else
        redirect_to root_path, status: :see_other
      end
    else
      redirect_to new_user_registration_path, status: :see_other, notice: "Authenticated failed"
    end
  end

  private

  def handle_omniauth(provider)
    user, _ = User.find_for_oauth(request.env["omniauth.auth"])

    if user&.persisted?
      sign_in user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?

      redirect_to root_path, status: :see_other
    else
      redirect_to new_user_session_path, alert: "Something went wrong"
    end
  end
end
