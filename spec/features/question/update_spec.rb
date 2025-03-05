require 'rails_helper'

feature 'User can update question', %q(
  As an authenticated user,
  I want to be able to update my question,
  So that I can correct errors or provide more details
  and get better answers from the community
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user is author' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'Author can edit a question' do
      fill_in 'Title', with: 'Another question'
      fill_in 'Body', with: 'Another test question body'
      click_on 'Submit'

      expect(page).to have_content 'Another question'
      expect(page).to have_content 'Another test question body'
    end

    scenario 'Author can edit a question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Submit'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticated user is not author' do
    background do
      sign_in(another_user)

      puts another_user.inspect
      puts user.inspect

      visit question_path(question)
    end

    scenario "Authenticated user can't see edit link if not author" do
      expect(page).not_to have_link('Edit')
    end

    scenario "Authenticated user can't access the edit page" do
      visit edit_question_path(question)

      expect(page).to have_content 'You are not authorized to perform this action.'
      expect(page).to have_current_path(root_path)
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user tries to edit a question' do
      visit question_path(question)

      expect(page).not_to have_link('Edit')
    end

    scenario "Authenticated user can't access the edit page" do
      visit edit_question_path(question)

      expect(page).to have_content 'You need to sign in or sign up before continuing'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

