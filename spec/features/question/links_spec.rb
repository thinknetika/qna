require 'rails_helper'

feature 'User can add links to question', js: true do
  %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
)
  given(:user) { create(:user) }
  given(:url) { 'https://github.com' }
  given(:another_url) { 'https://google.com' }
  given(:question) { create(:question, author: user) }

  background do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.', wait: 5
  end

  scenario 'User adds link when asks question' do
    visit questions_path

    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'Github'
    fill_in 'Url', with: url

    click_on 'Post question'

    expect(page).to have_link 'Google', href: url
  end

  describe 'when editing an question' do
    background do
      question.links.create(name: 'Github', url: url)

      visit question_path(question)
    end

    scenario 'User update link when asks question' do
      click_on 'Edit'

      fill_in 'Name', with: 'Google'
      fill_in 'Url', with: another_url

      click_on 'Post question'

      expect(page).to have_link 'Google', href: another_url
    end

    scenario 'User delete link when give an question' do
      click_on 'Edit'

      click_on 'Remove link'

      click_on 'Post question'

      expect(page).to_not have_link 'Github'
    end
  end
end
