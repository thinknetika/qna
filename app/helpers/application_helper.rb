module ApplicationHelper
  def questions_collection_cache_key(questions)
    count = questions.size
    max_updated_at = questions.maximum(:updated_at)&.utc&.to_s(:number)
    "questions/collection-#{count}-#{max_updated_at}"
  end
end