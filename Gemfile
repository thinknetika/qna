source "https://rubygems.org"

ruby "3.2.3"

gem 'active_model_serializers', '~> 0.10'
gem "aws-sdk-s3", require: false
gem "bootstrap"
gem "bootsnap", require: false
gem 'database_cleaner'
gem 'devise', '~> 4.2'
gem "font-awesome-sass"
gem "doorkeeper"
gem "image_processing", ">= 1.2"
gem "importmap-rails"
gem "jbuilder"
gem "jwt", "~> 2.0"
gem "mysql2", ">= 0.5"
gem 'oj'
gem "omniauth"
gem "omniauth-github"
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2", "~> 0.8.0"
gem "omniauth-oauth2"
gem "omniauth-yandex"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem 'pundit'
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem 'redis-rails'
gem "ruby-vips"
gem "sassc-rails"
gem "sidekiq"
gem "slim-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem 'thinking-sphinx', '~> 5.0'
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem 'unicorn'
gem 'whenever', require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 7.0.0"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "sqlite3"
end

group :development do
  gem "web-console"
  gem "pry-rails"
  gem "letter_opener"
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem "capybara"
  gem 'capybara-email'
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  gem "launchy"
end

group :production do
  gem "redis"
end