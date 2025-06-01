module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def mock_omniauth_provider(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
                                                                         provider: provider.to_s,
                                                                         uid: '12345678',
                                                                         info: {
                                                                           name: "#{provider} User",
                                                                           email: email.to_s
                                                                         },
                                                                         credentials: {
                                                                           token: 'mock_token',
                                                                           refresh_token: 'mock_refresh_token',
                                                                           expires_at: Time.now + 1.week
                                                                         }
                                                                       })
  end
end

