require 'rails_helper'

feature 'User can create an answer to the question', %q(
  As an authenticated user
  I would like to be able to create a new answer for a given questions
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Show'
    end

    scenario 'Authenticated user asks a question' do
      fill_in 'Your Answer', with: 'Question answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'Question answer'
    end

    scenario 'Authenticated user asks a question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user asks a question' do
    visit questions_path
    click_on 'Show'

    fill_in 'Your Answer', with: 'Question answer'
    click_on 'Answer'

    expect(page).to have_current_path(new_user_session_path)
  end
end
