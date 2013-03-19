source 'http://rubygems.org'

gem 'rails', github: 'rails/rails'

# for edge rails
gem 'journey',                         github: 'rails/journey'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'
gem 'arel',                            github: 'rails/arel'

gem 'rails_config'
gem 'turbolinks'

gem 'kaminari', github: 'amatsuda/kaminari'
gem 'kaminari-bootstrap', github: 'mcasimir/kaminari-bootstrap'

gem 'omniauth'
gem 'omniauth-github'
gem 'octokit'

gem 'mysql2'
gem 'bluecloth'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'

  gem 'launchy'

  gem 'guard'
  gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'rack-livereload'

  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'triglav-client'

  gem 'artii'
  gem 'capistrano_banner'
  gem 'thin'

  group :test do
    if !ENV['TRAVIS'] && RUBY_VERSION < '2.0'
      gem 'pry'
      gem 'pry-remote'
      gem 'pry-stack_explorer'
      gem 'pry-debugger'
    end

    gem 'rspec-rails',        github: 'rspec/rspec-rails'
    gem 'rspec',              github: 'rspec/rspec'
    gem 'rspec-core',         github: 'rspec/rspec-core'
    gem 'rspec-expectations', github: 'rspec/rspec-expectations'
    gem 'rspec-mocks',        github: 'rspec/rspec-mocks'

    gem 'capybara', '~> 2.0.0'

    gem 'factory_girl'
    gem 'database_cleaner'

    gem 'rake'

    gem 'simplecov'
    gem 'coveralls', require: false
  end
end

group :production do
  gem 'unicorn'
end

group :assets do
  # for edge rails
  gem 'sprockets',            github: 'sstephenson/sprockets'
  gem 'sprockets-rails',      github: 'rails/sprockets-rails'
  gem 'sass-rails',           github: 'rails/sass-rails'
  gem 'coffee-rails',         github: 'rails/coffee-rails'
  gem 'jquery-rails'
  gem 'bootstrap-sass-rails', github: 'yabawock/bootstrap-sass-rails'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end
