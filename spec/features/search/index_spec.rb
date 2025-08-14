require 'sphinx_helper'

feature 'User can search for content', %q(
  To find specific information
  As an authenticated or unauthenticated user
  I would like to be able to search for questions, answers, users and comments.
) do

  given!(:question) { create(:question, title: 'Ruby programming question', body: 'How to use Rails?') }
  given!(:answer) { create(:answer, body: 'You should use Ruby on Rails framework') }
  given!(:search_user) { create(:user, email: 'ruby@developer.com') }

  background do
    ThinkingSphinx::Test.run do
      visit root_path
    end
  end

  scenario 'User can search for questions', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Ruby programming'
      select 'Questions', from: 'category'
      click_button 'Search'

      expect(page).to have_content 'Search results for: Ruby programming', wait: 5
      expect(page).to have_content question.title
    end
  end

  scenario 'User can search for answers', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'You should use Ruby on Rails framework'
      select 'Answers', from: 'category'
      click_button 'Search'

      expect(page).to have_content 'Search results for: You should use Ruby on Rails framework', wait: 5
      expect(page).to have_content answer.body
    end
  end

  scenario 'User can search for users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'ruby@developer.com'
      select 'Users', from: 'category'
      click_button 'Search'

      expect(page).to have_content 'Search results for: ruby@developer.com', wait: 5
      expect(page).to have_content search_user.email
    end
  end

  scenario 'User can search in all categories', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Ruby'
      select 'All', from: 'category'
      click_button 'Search'

      expect(page).to have_content 'Search results for: Ruby'
      expect(page).to have_content 'Questions'
      expect(page).to have_content 'Answers'
      expect(page).to have_content 'Users'
    end
  end

  scenario 'Gets no results message when nothing found', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'nonexistent query xyz123'
      select 'Questions', from: 'category'
      click_button 'Search'

      expect(page).to have_content 'Search results for: nonexistent query xyz123'
      expect(page).to have_content 'No questions found'
    end
  end
end
