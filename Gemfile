source "https://rubygems.org"

gem "bootsnap", require: false
gem "devise"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "slim-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 6.0.0"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "sqlite3"
  gem "selenium-webdriver"
end

group :development do
  gem "web-console"
  gem 'pry-rails'
end

group :test do
  gem "capybara"
  gem "shoulda-matchers", "~> 6.0"
  gem "launchy"
end
