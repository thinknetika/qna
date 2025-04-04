require 'rails_helper'

feature 'User can add links to answer', js: true do
  %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
)

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:url) { 'https://github.com' }
  given!(:another_url) { 'https://google.com' }
  given!(:answer) { create(:answer, question: question, author: user) }

  background do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.', wait: 5
  end

  scenario 'User adds link when give an answer' do
    visit question_path(question)

    click_on('Post answer')

    fill_in 'Your Answer', with: 'My answer'

    fill_in 'Name', with: 'Github'
    fill_in 'Url', with: url

    click_on 'Post answer'

    within '#answers' do
      expect(page).to have_link 'Github', href: url
    end
  end

  describe 'when editing an answer' do
    background do
      answer.links.create(name: 'Github', url: url)

      visit question_path(question)
    end

    scenario 'User update link when give an answer' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'

        fill_in 'Name', with: 'Google'
        fill_in 'Url', with: another_url

        click_on 'Post answer'
      end

      within '#answers' do
        expect(page).to have_link 'Google', href: another_url
      end
    end

    scenario 'User delete link when give an answer' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'

        click_on 'Remove link'

        click_on 'Post answer'
      end

      within '#answers' do
        expect(page).to_not have_link 'Github'
      end
    end
  end
end
