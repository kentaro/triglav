ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rubygems'

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'

require 'factory_girl'
require 'database_cleaner'

require 'omniauth'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  OmniAuth.config.test_mode = true

  # capybara >= 2.0
  config.include Capybara::DSL

  # factory girl
  FactoryGirl.find_definitions
  config.include FactoryGirl::Syntax::Methods

  # database cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
