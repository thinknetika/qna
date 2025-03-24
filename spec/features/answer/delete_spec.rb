require 'rails_helper'

feature 'Author can delete his answer', js: true do
  "
  In order to delete answer
  As an authenticated user and question author
  I'd like to be able to delete my answer
"
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  scenario 'Authenticated author try to delete his answer' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.', wait: 5

    visit question_path(question)

    within "#answer_#{answer.id}" do
      accept_confirm do
        click_on 'Delete'
      end
    end

    expect(page).to have_current_path(question_path(question))
    expect(page).to_not have_selector "#answer_#{answer.id}"
  end

  scenario 'Authenticated not author user try to delete answer' do
    sign_in(another_user)
    expect(page).to have_content 'Signed in successfully.', wait: 5

    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user try to delete answer' do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).to_not have_link 'Delete'
    end
  end
end
