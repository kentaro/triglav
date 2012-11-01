#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)
Triglav::Application.load_tasks

desc 'setup files for development'
task 'setup' do
  %x{cp config/database.sample.yml config/database.yml}

  %w(test development).each do |env|
    %x{cp config/settings/environment.sample.yml config/settings/#{env}.yml}
  end

  %x{echo "Triglav::Application.config.secret_token = '`bundle exec rake secret`'" > config/initializers/secret_token.rb}
end
