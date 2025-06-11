FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { create(:user, :is_admin).id }
    application { create(:oauth_application) }
    token { SecureRandom.hex(32) }
    expires_in { 2.hours }
    scopes { '' }
  end
end
