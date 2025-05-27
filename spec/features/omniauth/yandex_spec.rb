require 'rails_helper'
require 'capybara/email/rspec'

feature "YandexOAuth", js: true do
  background do
    OmniAuth.config.test_mode = true
  end

  scenario 'Signs in via Yandex and redirects to edit profile if email is @example.com and confirms email' do
    mock_omniauth_provider(:yandex)

    visit new_user_session_path
    click_button 'Sign in with Yandex'

    # redirected to the edit profile page
    expect(page).to have_current_path(edit_user_registration_path)
    expect(page).to have_content('Edit User')

    # fill_in form with new user data
    new_email = 'user@yandex.ru'
    new_password = 'new_password'
    fill_in 'Email', with: new_email
    fill_in 'Password', with: new_password
    fill_in 'Password confirmation', with: new_password
    click_button 'Update'

    # check notice of confirm email
    expect(page).to have_content('You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirmation link to confirm your new email address.')

    # open the confirmation email and confirm account
    open_email(new_email)
    expect(current_email).to have_content('You can confirm your account email through the link below:')

    confirmation_link = current_email.find_link('Confirm my account')[:href]
    visit confirmation_link

    # current_email.click_link 'Confirm my account'
    expect(page).to have_content('Your email address has been successfully confirmed.')

    # logout & login
    find('a.nav-link.dropdown-toggle').click
    click_link 'Sign out'

    # log in with the new email & password
    visit new_user_session_path

    fill_in 'Email', with: new_email
    fill_in 'Password', with: new_password
    click_button 'Log in'

    # signed successfully
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Sign in via Yandex fails if user cannot be found' do
    mock_omniauth_provider(:yandex)
    allow(User).to receive(:find_for_oauth).and_return([nil, nil])

    visit new_user_session_path
    click_button 'Sign in with Yandex'

    expect(page).to have_current_path(new_user_registration_path)
    expect(page).to have_content('Authenticated failed')
  end
end
