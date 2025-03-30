require 'rails_helper'

feature 'Author can delete his answer', js: true do
  "
  In order to delete answer
  As an authenticated user and question author
  I'd like to be able to delete my answer
"
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, :with_question_files, author_id: user.id) }
  given!(:answer) { create(:answer, :with_answer_files, question_id: question.id, author_id: user.id) }

  describe 'Authenticated author' do
    background do
      sign_in(user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    describe 'Question' do
      scenario 'Authenticated author try to delete attached file' do
        within "#question_#{question.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{question.files.first.id}" do
            find('a[data-turbo-method="delete"]').click
          end

          expect(page).to_not have_content 'rails_helper.rb'

          within "#attachment_#{question.files.second.id}" do
            find('a[data-turbo-method="delete"]').click
          end

          expect(page).to_not have_content 'spec_helper.rb'
        end
      end
    end

    describe 'Answer' do
      scenario 'Authenticated author try to delete attached file' do
        within "#answer_#{answer.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{answer.files.first.id}" do
            find('a[data-turbo-method="delete"]').click
          end

          expect(page).to_not have_content 'rails_helper.rb'

          within "#attachment_#{answer.files.second.id}" do
            find('a[data-turbo-method="delete"]').click
          end

          expect(page).to_not have_content 'spec_helper.rb'
        end
      end
    end
  end

  describe 'Authenticated not author' do
    background do
      sign_in(another_user)
      expect(page).to have_content 'Signed in successfully.', wait: 5

      visit question_path(question)
    end

    describe 'Question' do
      scenario 'Authenticated author try to delete attached file' do
        within "#question_#{question.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{question.files.first.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end

          within "#attachment_#{question.files.second.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end
        end
      end
    end

    describe 'Answer' do
      scenario 'Authenticated author try to delete attached file' do
        within "#answer_#{answer.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{answer.files.first.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end

          within "#attachment_#{answer.files.second.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    describe 'Question' do
      scenario 'Authenticated author try to delete attached file' do
        within "#question_#{question.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{question.files.first.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end

          within "#attachment_#{question.files.second.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end
        end
      end
    end

    describe 'Answer' do
      scenario 'Authenticated author try to delete attached file' do
        within "#answer_#{answer.id}" do
          expect(page).to have_content 'rails_helper.rb'
          expect(page).to have_content 'spec_helper.rb'

          within "#attachment_#{answer.files.first.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end

          within "#attachment_#{answer.files.second.id}" do
            expect(page).to_not have_link 'a[data-turbo-method="delete"]'
          end
        end
      end
    end
  end
end

