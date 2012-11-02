source 'https://rubygems.org'

gem 'rails', github: 'rails/rails'

# for edge rails
gem 'journey',                         github: 'rails/journey'
gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'

gem 'rails_config'
gem 'turbolinks'

gem 'kaminari', github: 'amatsuda/kaminari'
gem 'kaminari-bootstrap', github: 'mcasimir/kaminari-bootstrap'

gem 'omniauth'
gem 'omniauth-github'
gem 'octokit'

gem 'mysql2'

group :development do
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'

  gem 'i18n_generators', github: 'amatsuda/i18n_generators'

  gem 'launchy'

  gem 'guard'
  gem 'guard-livereload'
  gem 'rb-fsevent'
  gem 'rack-livereload'

  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'artii'
  gem 'capistrano_banner'
  gem 'thin'
end

group :test do
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'

  gem 'rspec-rails',        github: 'rspec/rspec-rails'
  gem 'rspec',              github: 'rspec/rspec'
  gem 'rspec-core',         github: 'rspec/rspec-core'
  gem 'rspec-expectations', github: 'rspec/rspec-expectations'
  gem 'rspec-mocks',        github: 'rspec/rspec-mocks'

  # for capybara >=2.0
  gem 'capybara', github: 'jnicklas/capybara'

  gem 'factory_girl'
  gem 'database_cleaner'

  gem 'rake'
  gem 'rspec-formatter-beep', github: 'kentaro/rspec-formatter-beep'

  gem 'simplecov'
end

group :production do
  gem 'unicorn'
end

group :assets do
  # for edge rails
  gem 'sprockets',       github: 'sstephenson/sprockets'
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',      github: 'rails/sass-rails'
  gem 'coffee-rails',    github: 'rails/coffee-rails'
  gem 'jquery-rails'
  gem 'less-rails',      github: 'metaskills/less-rails'
  gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails'

  gem 'uglifier', '>= 1.0.3'
end
