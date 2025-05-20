class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :github

  def github
    @user, @password = User.find_for_oauth(request.env["omniauth.auth"])
    if @user&.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      set_flash_message(:alert, :error, "Something went wrong")
    end

    redirect_to root_path, status: :see_other
  end

  def google_oauth2
    @user, @password = User.find_for_oauth(request.env["omniauth.auth"])
    if @user&.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      set_flash_message(:alert, :error, "Something went wrong")
    end

    redirect_to root_path, status: :see_other
  end

  def yandex
    @user, @password = User.find_for_oauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Yandex") if is_navigational_format?

      if @user.email.include?('@example.com')
        session[:temporary_password] = @password

        redirect_to edit_user_registration_path, status: :see_other
      else
        redirect_to root_path, status: :see_other
      end
    else
      redirect_to new_user_registration_path, status: :see_other, notice: "Authenticated failed"
    end
  end
end

