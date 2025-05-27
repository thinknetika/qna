class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    if email.blank?
      email = temporary_email(auth.uid)
      generated_email = true
    end

    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      temporary_password = Devise.friendly_token[0, 20]

      user = User.new(
        email: email,
        password: temporary_password,
        password_confirmation: temporary_password)

      if generated_email
        user.skip_confirmation!
      else
        user.confirmed_at = Time.now
      end

      if user.save
        user.create_authorization(auth)
      else
        Rails.logger.error "Failed to create authorization after user creation."
      end
    end

    return user, temporary_password
  end

  def temporary_email(uid)
    "#{uid}@example.com"
  end
end
