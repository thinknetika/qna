require 'rails_helper'

feature "GitHubOAuth", js: true do
  background do
    OmniAuth.config.test_mode = true
  end

  scenario 'Signs in via GitHub' do
    mock_omniauth_provider(:github, "github@example.com")

    visit new_user_session_path
    click_button 'Sign in with GitHub'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Successfully authenticated from Github account.')
    expect(page).to have_content("github@example.com")
    expect(page).to have_no_button('Sign in with GitHub')
  end

  scenario 'Sign in via GitHub fails if user cannot be found' do
    mock_omniauth_provider(:github, email: 'another_user@example.com')
    allow(User).to receive(:find_for_oauth).and_return([nil, nil])

    visit new_user_session_path
    click_button 'Sign in with GitHub'

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Something went wrong')
  end
end
