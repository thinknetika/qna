require 'rails_helper'

feature 'The user can view the question', %q(
  To get information or find answers
  As an authenticated or non-authenticated user
  I would like to be able to view a specific question.
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Unauthenticated user can view the question' do
    visit questions_path
    click_on('Show')

    expect(page).to have_content question.title
    expect(page).to have_content question.body[0..50]

    question.answers.each do |answer|
      expect(page).to have_content answer.body[0..50]
    end
  end

  scenario 'Authenticated user can view the question' do
    sign_in(user)
    visit questions_path
    click_on('Show')

    expect(page).to have_content question.title
    expect(page).to have_content question.body[0..50]

    question.answers.each do |answer|
      expect(page).to have_content answer.body[0..50]
    end
  end
end
