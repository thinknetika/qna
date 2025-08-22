# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "qna"
set :repo_url, "git@github.com:thinknetika/qna.git"

set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'
set :branch, 'develop'

append :linked_files, "config/database.yml", 'config/master.key'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage'

set :rvm_path, '/usr/share/rvm'
set :rvm_custom_path, '/usr/share/rvm'
set :rvm_ruby_version, '3.2.3'