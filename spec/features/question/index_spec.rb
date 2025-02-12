require 'rails_helper'

feature 'User can view all the questions', %q(
  To get information or find answers
  As an authenticated or unauthenticated user
  I would like to be able to view all the questions.
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'Unauthenticated user can view all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body[0..50]
    end
  end

  scenario 'Authenticated user can view all questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body[0..50]
    end
  end
end
