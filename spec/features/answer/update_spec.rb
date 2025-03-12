require 'rails_helper'

feature 'User can update answer', js: true do
  %q(
  As an authenticated user,
  I want to be able to update my answer,
  So that I can correct errors or provide more details
  and get better answers from the community
)
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  describe 'Authenticated user is author' do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_on 'Edit'
      end
    end

    scenario 'Author can edit an answer' do
      within "#answer_#{answer.id}" do
        fill_in 'Your Answer', with: 'Another test answer body'
        click_on 'Post Answer'
      end

      expect(page).to have_content 'Another test answer body'
    end

    scenario 'Author can edit a answer with errors' do
      within "#answer_#{answer.id}" do
        fill_in 'Your Answer', with: ''
        click_on 'Post Answer'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticated user is not author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    scenario "Authenticated user can't see edit link if not author" do
      within "#answer_#{answer.id}" do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario "Authenticated user can't access the edit page" do
      visit edit_answer_path(answer)

      expect(page).to have_content 'You are not authorized to perform this action.'
      expect(page).to have_current_path(root_path)
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'Unauthenticated user tries to edit a question' do
      within "#answer_#{answer.id}" do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario "Unauthenticated user can't access the edit page" do
      visit edit_answer_path(answer)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
