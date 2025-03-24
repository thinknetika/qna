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
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user is author', js: true do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5
    end

    describe 'On questions/show' do
      background do
        visit question_path(question)

        click_on 'Edit'
      end

      scenario 'Author can edit a question' do
        within "#question_#{question.id}" do
          fill_in 'question_title', with: 'Another question'
          fill_in 'question_body', with: 'Another test question body'

          click_on 'Post question'
        end

        expect(page).to have_current_path(question_path(question))
        expect(page).to have_content 'Another question'
        expect(page).to have_content 'Another test question body'
      end

      scenario 'Author can edit a question with errors' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''

        click_on 'Post question'

        expect(page).to have_current_path(question_path(question))
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'On questions/index' do
      background do
        visit questions_path

        click_on 'Edit'
      end

      scenario 'Author can edit a question' do
        within "#question_#{question.id}" do
          fill_in 'question_title', with: 'Another question'
          fill_in 'question_body', with: 'Another test question body'

          click_on 'Post question'
        end

        expect(page).to have_current_path(questions_path)
        expect(page).to have_content 'Another question'
        expect(page).to have_content 'Another test question body'
      end

      scenario 'Author can edit a question with errors' do
        within "#question_#{question.id}" do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''

          click_on 'Post question'
        end

        expect(page).to have_current_path(questions_path)
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Authenticated user is not author' do
    background do
      sign_in(another_user)

      expect(page).to have_content 'Signed in successfully.', wait: 5
    end

    describe 'On questions/show' do
      scenario "Authenticated user can't see edit link if not author" do
        visit question_path(question)

        expect(page).not_to have_link('Edit')
      end
    end

    describe 'On questions/index' do
      scenario "Authenticated user can't see edit link if not author" do
        visit questions_path

        expect(page).not_to have_link('Edit')
      end
    end

    scenario "Authenticated user can't access the edit page" do
      visit edit_question_path(question, source_view: 'index')

      expect(page).to have_content 'You are not authorized to perform this action.'
      expect(page).to have_current_path(root_path)
    end
  end

  describe 'Unauthenticated user' do
    describe 'On questions/show' do
      scenario 'Unauthenticated user tries to edit a question' do
        visit question_path(question)

        expect(page).not_to have_link('Edit')
      end
    end

    describe 'On questions/index' do
      scenario 'Unauthenticated user tries to edit a question' do
        visit questions_path

        expect(page).not_to have_link('Edit')
      end
    end
  end
end
