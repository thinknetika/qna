class DailyDigest
  def send_digest
    questions = Question.where('created_at > ?', 1.day.ago).to_a

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
