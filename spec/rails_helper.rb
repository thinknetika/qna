require 'pry'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'support/capybara'
require 'rspec/rails'
require 'capybara/email/rspec'
require 'pundit/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include ApiHelpers, type: :request
  config.fixture_paths = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.render_views = true
  config.include Capybara::Email::DSL

  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
