# XXX This is just an example.
require 'capistrano_colors'
require 'capistrano_banner'
require 'bundler/capistrano'

require 'json'
require 'open-uri'

set :application,  "triglav"
set :deploy_to,    "/var/www/#{application}"
set :repository,   "git://github.com/kentaro/triglav.git"
set :scm,          :git
set :bundle_flags, "--deployment --without development test"

before 'deploy:assets:precompile' do
  run "cd #{deploy_to} && cp -R local/config #{latest_release}"
end

triglav_host = 'triglav.pb'
api_token    = 'P96i2OUWQv_HdyXcSKHcuw'

%w(app web).each do |name|
  role name.to_sym do
    open "http://#{triglav_host}/api/services/#{application}/roles/#{name}/hosts?api_token=#{api_token}" do |f|
      json  = f.read
      hosts = JSON.parse(json)
      hosts.map { |host| host['host']['name'] }
    end
  end
end

namespace :deploy do
  %w(start stop restart).each do |command|
    task command.to_sym, roles: :app do
      run "supervisorctl #{command} #{application}"
    end
  end

  task :log, roles: :app do
    stream "tail -f #{deploy_to}/shared/log/production.log"
  end
end

banner force: true
