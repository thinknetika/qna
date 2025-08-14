class SearchService
  def self.search(query, category)
    results = {}
    query = ThinkingSphinx::Query.escape(query)

    case category
    when "questions"
      results[:questions] = Question.search(query)
    when "answers"
      results[:answers] = Answer.search(query)
    when "users"
      results[:users] = User.search(query)
    when "comments"
      results[:comments] = Comment.search(query)
    else
      results[:questions] = Question.search(query)
      results[:answers] = Answer.search(query)
      results[:users] = User.search(query)
      results[:comments] = Comment.search(query)
    end

    results
  end
end
