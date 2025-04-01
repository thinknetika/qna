require 'rails_helper'

feature 'User can add links to answer', js: true do
  %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
)
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://github.com' }
  given(:another_url) { 'https://google.com' }

  background do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.', wait: 5

    visit question_path(question)
  end
  scenario 'User adds link when give an answer' do
    click_on('Post answer')

    fill_in 'Your Answer', with: 'My answer'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: url


    click_on 'Post answer'

    within '#answers' do
      expect(page).to have_link 'My gist', href: url
    end
  end

  scenario 'User update link when give an answer' do
    visit question_path(question)

    click_on('Post answer')

    fill_in 'Your Answer', with: 'My answer'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: another_url

    click_on 'Post answer'

    within '#answers' do
      expect(page).to have_link 'My gist', href: another_url
    end
  end
end
