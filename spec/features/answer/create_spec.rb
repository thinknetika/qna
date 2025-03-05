require 'rails_helper'

feature 'User can create an answer to the question', js: true do
  %q(
    As an authenticated user
    I would like to be able to create a new answer for a given questions
  )

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'Authenticated user asks a question' do
      fill_in 'Your Answer', with: 'Question answer'
      click_on 'Answer'

      expect(page).to have_content 'Question answer'
      expect(current_path).to eq question_path(question)
    end

    scenario 'Authenticated user asks a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
      expect(page).to have_current_path(question_path(question))
    end
  end

  scenario 'Unauthenticated user can not post answer' do
    visit question_path(question)

    expect(page).to_not have_content('Your Answer')
  end
end
