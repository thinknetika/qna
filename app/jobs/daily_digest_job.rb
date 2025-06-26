class DailyDigestJob < ApplicationJob
  queue_as :daily_digest

  def perform
    DailyDigest.new.send_digest
  end
end
