# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(email: 'user1@mail.ru', password: '123456')
User.create!(email: 'user2@mail.ru', password: '123456')

question = Question.create!(title: 'title question 1', body: 'body question 1', author: user)
Question.create!(title: 'title question 2', body: 'body question 2', author: user)
Question.create!(title: 'title question 3', body: 'body question 3', author: user)

Answer.create!(body: 'answer question 1', question: question, author: user)
Answer.create!(body: 'answer question 2', question: question, author: user)
Answer.create!(body: 'answer question 3', question: question, author: user)
