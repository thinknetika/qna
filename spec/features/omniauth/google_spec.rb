require 'rails_helper'

feature "GoogleOAuth", js: true do
  background do
    OmniAuth.config.test_mode = true
  end

  scenario 'Signs in via Google' do
    mock_omniauth_provider(:google_oauth2, 'google@example.com')

    visit new_user_session_path
    click_button 'Sign in with Google'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Successfully authenticated from Google_oauth2 account.')
    expect(page).to have_content('google@example.com')
    expect(page).to have_no_button('Sign in with Google')
  end

  scenario 'Sign in via Google fails if user cannot be found' do
    mock_omniauth_provider(:google_oauth2, email: 'another_user@gmail.com')
    allow(User).to receive(:find_for_oauth).and_return([nil, nil])

    visit new_user_session_path
    click_button 'Sign in with Google'

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Something went wrong')
  end
end
