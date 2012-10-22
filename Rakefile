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
  password:
  database: hyperion_test
  host: localhost
  encoding: utf8
EOS
    end

    open(File.expand_path('../config/settings/test.yml', __FILE__), 'w') do |f|
      f.write <<EOS
github:
  organization: hyperion
EOS
    end

    open(File.expand_path('../config/initializers/secret_token.rb', __FILE__), 'w') do |f|
      token = `bundle exec rake secret`.strip
      f.write <<"EOS"
Hyperion::Application.config.secret_token = '#{token}'
EOS
    end
  end
end
