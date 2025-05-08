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
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)

      within "#new_answer" do
        click_on 'Post answer'
      end
    end

    scenario 'Authenticated user write answer' do
      within "#new_answer" do
        fill_in 'Your Answer', with: 'Question answer'

        click_on 'Post answer'
      end

      expect(page).to have_content 'Question answer'
      expect(current_path).to eq question_path(question)
    end

    scenario 'Authenticated user write answer with errors' do
      within "#new_answer" do
        fill_in 'Your Answer', with: ''

        click_on 'Post answer'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Authenticated user write answer with attached files' do
      within "#new_answer" do
        fill_in 'Your Answer', with: 'Question answer'

        attach_file 'answer[files][]', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

        click_on 'Post answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user can not post answer' do
      visit question_path(question)

      expect(page).not_to have_link('Post answer')
    end

    scenario "Unauthenticated user can't access to the create new answer" do
      visit new_question_answer_path(question)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "multiple sessions" do
    scenario "question appears on another user's page" do
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

      Capybara.using_session('user_1') do
        within "#new_answer" do
          click_on 'Post answer'

          fill_in 'Your Answer', with: 'Question answer'

          click_on 'Post answer'
        end

        expect(page).to have_content 'Question answer'
        expect(current_path).to eq question_path(question)
      end

      Capybara.using_session('user_2') do
        expect(page).to have_content 'Question answer'
        expect(current_path).to eq question_path(question)
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Question answer'
        expect(current_path).to eq question_path(question)
      end
    end
  end
end
