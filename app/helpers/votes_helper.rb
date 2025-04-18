module VotesHelper
  def vote_path_for(votable, value)
    if votable.is_a?(Question)
      vote_question_path(votable.id, value: value)
    elsif votable.is_a?(Answer)
      vote_answer_path(votable.id, value: value)
    else
      raise ArgumentError, "Unsupported votable type: #{votable.class.name}"
    end
  end
end