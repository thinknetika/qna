require 'rails_helper'

feature 'Author can delete his answer & question comments', js: true do
  "
  In order to delete answer & question comments
  As an authenticated user and comments author
  I'd like to be able to delete my comment
"
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }
  given!(:question_comment) { create(:comment, commentable: question, author_id: user.id) }
  given!(:answer_comment) { create(:comment, commentable: answer, author_id: user.id) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    context 'to question' do
      scenario 'Authenticated author try to delete his question comment' do
        within "#comment_#{question_comment.id}" do
          accept_confirm do
            click_on 'Delete'
          end
        end

        expect(page).to have_current_path(question_path(question))
        expect(page).to_not have_selector "#comment_#{question_comment.id}"
      end
    end

    context 'to answer' do
      scenario 'Authenticated author try to delete his answer comment' do
        within "#comment_#{answer_comment.id}" do
          accept_confirm do
            click_on 'Delete'
          end
        end

        expect(page).to have_current_path(question_path(question))
        expect(page).to_not have_selector "#comment_#{answer_comment.id}"
      end
    end
  end

  describe 'Authenticated not author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    context 'to question' do
      scenario "Authenticated user can't see question comment delete link if not author" do
        within "#comment_#{question_comment.id}" do
          expect(page).not_to have_link('Delete')
        end
      end
    end

    context 'to answer' do
      scenario "Authenticated user can't see answer comment delete link if not author" do
        within "#comment_#{answer_comment.id}" do
          expect(page).not_to have_link('Delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    context 'to question' do
      scenario "Unauthenticated user can't see question comment delete link if not author" do
        within "#comment_#{question_comment.id}" do
          expect(page).not_to have_link('Delete')
        end
      end
    end

    context 'to answer' do
      scenario "Unauthenticated user can't see answer comment delete link if not author" do
        within "#comment_#{answer_comment.id}" do
          expect(page).not_to have_link('Delete')
        end
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
            accept_confirm do
              click_on 'Delete'
            end
          end

          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{question_comment.id}"
        end

        Capybara.using_session('user_2') do
          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{question_comment.id}"
        end

        Capybara.using_session('guest') do
          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{question_comment.id}"
        end
      end
    end

    context "to answer" do
      scenario "answer comment appears on another user's page" do
        Capybara.using_session('user_1') do
          within "#comment_#{answer_comment.id}" do
            accept_confirm do
              click_on 'Delete'
            end
          end

          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{answer_comment.id}"
        end

        Capybara.using_session('user_2') do
          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{answer_comment.id}"
        end

        Capybara.using_session('guest') do
          expect(page).to have_current_path(question_path(question))
          expect(page).to_not have_selector "#comment_#{answer_comment.id}"
        end
      end
    end
  end
end
