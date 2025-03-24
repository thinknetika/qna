require 'rails_helper'

feature 'Author can delete his question', js: true do
  "  In order to delete question
  As an authenticated user and question author
  I'd like to be able to delete my question"

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5
    end

    scenario 'On questions/show try to delete his question' do
      visit question_path(question)

      within "#question_#{question.id}" do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(page).to have_current_path(questions_path)

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'On questions/index try to delete his question' do
      visit questions_path

      within "#question_#{question.id}" do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end
  end

  describe 'Authenticated user is not author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5
    end

    scenario 'On questions/show try to delete his question' do
      visit question_path(question)

      within "#question_#{question.id}" do
        expect(page).to_not have_button 'Delete'
      end
    end

    scenario 'On questions/index try to delete his question' do
      visit questions_path

      within "#question_#{question.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'On questions/show try to delete question' do
      visit questions_path

      within "#question_#{question.id}" do
        expect(page).to_not have_button 'Delete'
      end
    end

    scenario 'On questions/index try to delete question' do
      visit questions_path

      within "#question_#{question.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
