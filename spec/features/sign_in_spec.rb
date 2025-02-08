require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask question
  As an unauthenticated user
  Id like to be able to sign in
) do
  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end


  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong_user@test.ru'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
