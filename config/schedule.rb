every 1.day do
  runner "DailyDigestJob.perform_now"
end

# thinking sphinx scheduled
every 15.minutes do
  rake "ts:merge"
end

every 30.minutes do
  rake "ts:index"
end
