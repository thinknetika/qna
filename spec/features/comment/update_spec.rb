require 'rails_helper'

feature 'User can update question & answer comment', js: true do
  %q(
  As an authenticated user,
  I want to be able to update question & answer comment,
  So that I can correct errors or provide more details
)
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
  given!(:question_comment) { create(:comment, commentable: question, author_id: user.id) }
  given!(:answer_comment) { create(:comment, commentable: answer, author_id: user.id) }

  describe 'Authenticated user is author' do
    context 'to question' do
      background do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)

        within "#comment_#{question_comment.id}" do
          click_on 'Edit'
        end
      end

      scenario 'Author can edit an question comment' do
        within "#comment_#{question_comment.id}" do
          fill_in 'Body', with: 'Another question comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Another question comment'
      end

      scenario 'Author can edit a question comment with errors' do
        within "#comment_#{question_comment.id}" do
          fill_in 'Body', with: ''
          click_on 'Add Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    context 'to answer' do
      background do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)

        within "#comment_#{answer_comment.id}" do
          click_on 'Edit'
        end
      end

      scenario 'Author can edit an answer comment' do
        within "#comment_#{answer_comment.id}" do
          fill_in 'Body', with: 'Another answer comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Another answer comment'
      end

      scenario 'Author can edit a answer comment with errors' do
        within "#comment_#{answer_comment.id}" do
          fill_in 'Body', with: ''
          click_on 'Add Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Authenticated user is not author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    context 'to_question' do
      scenario "Authenticated user can't see question comment edit link if not author" do
        within "#comment_#{question_comment.id}" do
          expect(page).not_to have_link('Edit')
        end
      end

      scenario "Authenticated user can't access the question comment edit page" do
        visit edit_comment_path(question_comment)

        expect(page).to have_content 'You are not authorized to perform this action.'
      end
    end

    context 'to_answer' do
      scenario "Authenticated user can't see answer comment edit link if not author" do
        within "#comment_#{answer_comment.id}" do
          expect(page).not_to have_link('Edit')
        end
      end

      scenario "Authenticated user can't access the answer comment edit page" do
        visit edit_comment_path(answer_comment)

        expect(page).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    context 'to_question' do
      scenario 'Unauthenticated user tries to edit a question comment' do
        within "#comment_#{question_comment.id}" do
          expect(page).not_to have_link('Edit')
        end
      end

      scenario "Unauthenticated user can't access the question comment edit page" do
        visit edit_comment_path(question_comment)

        expect(page).to have_content 'You need to sign in or sign up before continuing'
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'to_answer' do
      scenario 'Unauthenticated user tries to edit a answer comment' do
        within "#comment_#{answer_comment.id}" do
          expect(page).not_to have_link('Edit')
        end
      end

      scenario "Unauthenticated user can't access the answer comment edit page" do
        visit edit_comment_path(answer_comment)

        expect(page).to have_content 'You need to sign in or sign up before continuing'
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe "multiple sessions" do
    background do
      Capybara.using_session('user_1') do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)
      end

      Capybara.using_session('user_2') do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end
    end

    context "to question" do
      scenario "question comment appears on another user's page" do
        Capybara.using_session('user_1') do
          within "#comment_#{question_comment.id}" do
            click_on 'Edit'

            fill_in 'Body', with: 'Another question comment'
            click_on 'Add Comment'
          end

          expect(page).to have_content 'Another question comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('user_2') do
          expect(page).to have_content 'Another question comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Another question comment'
          expect(current_path).to eq question_path(question)
        end
      end
    end

    context "to answer" do
      scenario "answer comment appears on another user's page" do
        Capybara.using_session('user_1') do
          within "#comment_#{answer_comment.id}" do
            click_on 'Edit'

            fill_in 'Body', with: 'Another answer comment'
            click_on 'Add Comment'
          end

          expect(page).to have_content 'Another answer comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('user_2') do
          expect(page).to have_content 'Another answer comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Another answer comment'
          expect(current_path).to eq question_path(question)
        end
      end
    end
  end
end
