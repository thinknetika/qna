require 'rails_helper'

feature 'User can create an comment to the question & answer', js: true do
  %q(
    As an authenticated user
    I would like to be able to create a new comment for a given questions & answers
  )

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, :with_answer_files, question_id: question.id, author_id: user.id) }

  describe 'Authenticated user' do
    context 'to question' do
      background do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)

        within "#question_#{question.id}" do
          click_on 'Add Comment'
        end
      end

      scenario 'Authenticated user write question comment' do
        within "#question_new_comment" do
          fill_in 'comment_body', with: 'Question comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Question comment'
        expect(current_path).to eq question_path(question)
      end

      scenario 'Authenticated user write question comment with errors' do
        within "#question_new_comment" do
          click_on 'Add Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    describe 'to answer' do
      background do
        sign_in(user)
        expect(page).to have_content 'Signed in successfully.', wait: 5

        visit question_path(question)

        within "#answer_#{answer.id}" do
          click_on 'Add Comment'
        end
      end

      scenario 'Authenticated user write answer comment' do
        within "#answer_new_comment" do
          fill_in 'comment_body', with: 'Answer comment'
          click_on 'Add Comment'
        end

        expect(page).to have_content 'Answer comment'
        expect(current_path).to eq question_path(question)
      end

      scenario 'Authenticated user write answer comment with errors' do
        within "#answer_new_comment" do
          click_on 'Add Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    context 'to question' do
      scenario 'Unauthenticated user can not post question comment' do
        visit question_path(question)

        expect(page).not_to have_button('Add Comment')
      end

      scenario "Unauthenticated user can't access to the create new question comment" do
        visit new_question_comment_path(question)

        expect(page).to have_content 'You need to sign in or sign up before continuing.'
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    describe 'to answer' do
      scenario 'Unauthenticated user can not post answer comment' do
        visit question_path(question)

        expect(page).not_to have_button('Add Comment')
      end

      scenario "Unauthenticated user can't access to the create new answer comment" do
        visit new_answer_comment_path(answer)

        expect(page).to have_content 'You need to sign in or sign up before continuing.'
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
          within "#question_#{question.id}" do
            click_on 'Add Comment'
          end

          within "#question_new_comment" do
            fill_in 'comment_body', with: 'Question comment'
            click_on 'Add Comment'
          end

          expect(page).to have_content 'Question comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('user_2') do
          expect(page).to have_content 'Question comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Question comment'
          expect(current_path).to eq question_path(question)
        end
      end
    end

    context "to answer" do
      scenario "answer comment appears on another user's page" do
        Capybara.using_session('user_1') do
          within "#answer_#{answer.id}" do
            click_on 'Add Comment'
          end

          within "#answer_new_comment" do
            fill_in 'comment_body', with: 'Answer comment'
            click_on 'Add Comment'
          end

          expect(page).to have_content 'Answer comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('user_2') do
          expect(page).to have_content 'Answer comment'
          expect(current_path).to eq question_path(question)
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Answer comment'
          expect(current_path).to eq question_path(question)
        end
      end
    end
  end
end
