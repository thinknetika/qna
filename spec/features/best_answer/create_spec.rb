require 'rails_helper'

feature 'Question author can mark the best answer', js: true do
  %q(
end
  In order to reward helpful answers and highlight the most useful information
  As the author of the question
  I'd like to be able to mark one of the answers as the be
)
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer_1) { create(:answer, question_id: question.id, author_id: user.id) }
  given!(:answer_2) { create(:answer, question_id: question.id, author_id: user.id) }
  given!(:answer_3) { create(:answer, question_id: question.id, author_id: user.id) }

  describe 'Authenticated user is question author' do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    scenario 'Question author can mark a answer' do
      within "#answer_#{answer_1.id}" do
        click_on 'Mark as best'
      end

      within "#answer_#{answer_1.id}" do
        expect(page).to have_selector("turbo-frame[id='answer_#{answer_1.id}'] input[type='hidden'][id='best_answer']", visible: :hidden)
      end

      within "#answers" do
        expect(page.all('turbo-frame').first['id']).to eq "answer_#{answer_1.id}"
      end
    end

    scenario 'Question author can change the best answer' do

      within "#answer_#{answer_1.id}" do
        click_on 'Mark as best'
      end

      within "#answer_#{answer_2.id}" do
        click_on 'Mark as best'
      end

      within "#answer_#{answer_1.id}" do
        expect(page).to_not have_selector("turbo-frame[id='answer_#{answer_1.id}'] input[type='hidden'][id='best_answer']", visible: :hidden)
      end

      within "#answer_#{answer_2.id}" do
        expect(page).to have_selector("turbo-frame[id='answer_#{answer_2.id}'] input[type='hidden'][id='best_answer']", visible: :hidden)
      end

      within "#answers" do
        expect(page.all('turbo-frame').first['id']).to eq "answer_#{answer_1.id}"
      end
    end
  end

  describe 'Authenticated user is not question author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    scenario "Authenticated user can't see mark as best button" do
      answer = page.all('turbo-frame')

      answer.each do |answer|
        within answer do
          expect(page).to_not have_button('Mark as best')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario "Authenticated user can't see mark as best button" do
      answer = page.all('turbo-frame')

      answer.each do |answer|
        within answer do
          expect(page).to_not have_button('Mark as best')
        end
      end
    end
  end
end
