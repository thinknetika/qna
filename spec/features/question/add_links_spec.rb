require 'rails_helper'

feature 'User can add links to question', js: true do
  %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
)
  given(:user) { create(:user) }
  given(:url) { 'https://github.com' }
  given(:another_url) { 'https://github.com' }
  given(:question) { create(:question, author_id: user.id) }

  background do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.', wait: 5
  end

  scenario 'User adds link when asks question' do
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: url

    click_on 'Post question'

    expect(page).to have_link 'My gist', href: url
  end

  scenario 'User update link when asks question' do
    visit question_path(question)

    click_on 'Edit'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: another_url

    click_on 'Post question'

    expect(page).to have_link 'My gist', href: another_url
  end
end

