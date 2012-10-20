#!/usr/bin/env ruby

open(File.expand_path('../../config/database.yml', __FILE__), 'w') do |f|
  f.write <<EOS
test:
  adapter: mysql2
  username: root
  database: hyperion_test
  encoding: utf8
EOS
end

open(File.expand_path('../../config/settings/test.yml', __FILE__), 'w') do |f|
  f.write <<EOS
github:
  organization: hyperion
EOS
end

`bundle exec rake secret > config/initializers/secret_token.rb`
