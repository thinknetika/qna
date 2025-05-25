require 'rails_helper'

feature "GitHubOAuth", js: true do
  background do
    OmniAuth.config.test_mode = true

    def mock_github_auth(email)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid: '12345678',
                                                                    info: {
                                                                      name: 'GitHub User',
                                                                      email: email
                                                                    },
                                                                    credentials: {
                                                                      token: 'mock_token',
                                                                      refresh_token: 'mock_refresh_token',
                                                                      expires_at: Time.now + 1.week
                                                                    }
                                                                  })
    end

    mock_github_auth('user@gmail.com')
  end

  scenario 'Signs in via GitHub' do
    visit new_user_session_path
    click_button 'Sign in with GitHub'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Successfully authenticated from Github account.')
    expect(page).to have_content('user@gmail.com')
    expect(page).to have_no_button('Sign in with GitHub')
  end

  scenario 'Sign in via GitHub fails if user cannot be found' do
    mock_github_auth(email: 'another_user@example.com')
    allow(User).to receive(:find_for_oauth).and_return([nil, nil])

    visit new_user_session_path
    click_button 'Sign in with GitHub'

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('Something went wrong')
  end
end
