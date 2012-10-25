# XXX This is just an example.
require 'capistrano_colors'
require 'capistrano_banner'
require 'bundler/capistrano'

set :application,  "hyperion"
set :deploy_to,    "/var/www/#{application}"
set :repository,   "git://github.com/kentaro/hyperion.git"
set :scm,          :git
set :bundle_flags, "--deployment --without development test"

before 'deploy:assets:precompile' do
  run "cd #{deploy_to} && cp -R local/config #{latest_release}"
end

namespace :deploy do
  %w(start stop restart).each do |command|
    task command.to_sym do
      run "supervisorctl #{command} #{application}"
    end
  end

  task :log do
    stream "tail -f #{deploy_to}/shared/log/production.log"
  end
end

banner force: true
