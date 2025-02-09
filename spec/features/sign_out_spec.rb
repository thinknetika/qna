require 'rails_helper'

feature 'The user can log out', %q(
  To end the session
  As an authenticated user
  I want to be able to log out
) do
  given(:user) { create(:user) }

  scenario 'User tries to sign out' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'

    page.driver.submit :delete, destroy_user_session_path, {}
    expect(page).to have_content 'Signed out successfully.'
  end
end
