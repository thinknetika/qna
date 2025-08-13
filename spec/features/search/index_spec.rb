require 'rails_helper'

feature 'User can search for content', %q(
  To find specific information
  As an authenticated or unauthenticated user
  I would like to be able to search for questions, answers, users and comments.
) do

  given!(:question) { create(:question, title: 'Ruby programming question', body: 'How to use Rails?') }
  given!(:answer) { create(:answer, body: 'You should use Ruby on Rails framework') }
  given!(:search_user) { create(:user, email: 'ruby@developer.com') }

  background do
    visit root_path
  end

  scenario 'User can search for questions', js: true do
    fill_in 'query', with: 'Ruby programming'
    select 'Questions', from: 'category'
    click_button 'Search'

    expect(page).to have_content 'Search results for: Ruby programming', wait: 5
    expect(page).to have_content question.title
  end

  scenario 'User can search for answers', js: true do
    fill_in 'query', with: 'You should use Ruby on Rails framework'
    select 'Answers', from: 'category'
    click_button 'Search'

    save_and_open_screenshot

    expect(page).to have_content 'Search results for: You should use Ruby on Rails framework', wait: 5
    save_and_open_screenshot
    expect(page).to have_content answer.body
  end

  scenario 'User can search for users', js: true do
    fill_in 'query', with: 'ruby@developer.com'
    select 'Users', from: 'category'
    click_button 'Search'

    save_and_open_screenshot

    expect(page).to have_content 'Search results for: ruby@developer.com', wait: 5
    save_and_open_screenshot
    expect(page).to have_content search_user.body
  end

  scenario 'User can search in all categories', js: true do
    fill_in 'query', with: 'Ruby'
    select 'All', from: 'category'
    click_button 'Search'

    expect(page).to have_content 'Search results for: Ruby'
    expect(page).to have_content 'Questions'
    expect(page).to have_content 'Answers'
    expect(page).to have_content 'Users'
  end

  scenario 'Gets no results message when nothing found', js: true do
    visit root_path

    fill_in 'query', with: 'nquery xyz123'
    select 'Questions', from: 'category'
    click_button 'Search'

    expect(page).to have_content 'Search results for: nonexistent query xyz123'
    expect(page).to have_content 'No questions found'
  end
end
