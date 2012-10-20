#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)
Hyperion::Application.load_tasks

namespace :travis do
  desc 'setup files for travis-ci'
  task 'setup' do
    open(File.expand_path('../config/database.yml', __FILE__), 'w') do |f|
      f.write <<EOS
test:
  adapter: mysql2
  username: root
  database: hyperion_test
  encoding: utf8
EOS
    end

    open(File.expand_path('../config/settings/test.yml', __FILE__), 'w') do |f|
      f.write <<EOS
github:
  organization: hyperion
EOS
    end

    "Hyperion::Application.config.secret_token = '#{`bundle exec rake secret > config/initializers/secret_token.rb`}'"
  end
end
