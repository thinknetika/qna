module SearchHelper
  def search_results(category, results)
    capture do
      concat render(partial: 'search/questions', locals: { results: results }) if category == "questions" || category == "all"
      concat render(partial: 'search/answers', locals: { results: results }) if category == "answers" || category == "all"
      concat render(partial: 'search/users', locals: { results: results }) if category == "users" || category == "all"
      concat render(partial: 'search/comments', locals: { results: results }) if category == "comments" || category == "all"
    end
  end
end
