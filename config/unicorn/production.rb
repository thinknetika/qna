app_path = "/home/deployer/qna"
working_directory "#{app_path}/current"

pid "#{app_path}/shared/tmp/pids/unicorn.pid"

listen "#{app_path}/shared/tmp/sockets/unicorn.qna.sock", backlog: 64

stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"

worker_processes 2

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # PID файл не существует или процесс уже завершен
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
