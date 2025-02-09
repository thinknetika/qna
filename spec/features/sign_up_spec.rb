require 'rails_helper'

feature 'The user can register in the system', %q(
  To be able to
  As an authenticated user
  Use the functions available to the registered user
) do
  background { visit new_user_registration_path }

  scenario 'User is trying to register with valid data' do
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User is trying to register with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
