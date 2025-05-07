require 'rails_helper'

feature 'User can create question', js: true do
  %q(
end
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
)
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Authenticated user asks a question' do
      fill_in 'question_title', with: 'Test question'
      fill_in 'question_body', with: 'Test question body'

      click_on 'Post question'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test question body'
    end

    scenario 'Authenticated user asks a question with errors' do
      click_on 'Post question'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Authenticated asks a question with attached files' do
      fill_in 'question_title', with: 'Test question'
      fill_in 'question_body', with: 'text text text'

      attach_file 'question[files][]', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'Post question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Unauthenticated user it is not possible to ask a question' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "multiple sessions" do
    scenario "question appears on another user's page" do
      Capybara.using_session('user_1') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('user_2') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user_1') do
        click_on 'Ask question'

        fill_in 'question_title', with: 'Test question'
        fill_in 'question_body', with: 'test text'

        click_on 'Post question'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('user_2') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end
    end
  end
end
