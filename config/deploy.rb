require "bundler/capistrano"
set :application, "<dummy>"
set :repository, "<repository>"
set :deploy_to, "<url>"

set :user, "<user>"
set :password, "<pass>"

ssh_options[:forward_agent] = true
# Get prompted for the sudo password
default_run_options[:pty] = true
set :branch, "develop"

set :scm, :git

role :web, "<url>" # Your HTTP server, Apache/etc
role :app, "<url>" # This may be the same as your `Web` server
role :db,  "<url>", :primary => true # This is where Rails migrations will run


# This is supposed to help with asset compiling cant find file error
set :normalize_asset_timestamps, false

after "deploy", "symlink_configs", "deploy:restart", "deploy:cleanup", "deploy:compile_assets"

namespace :deploy do
  task :compile_assets do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

task :symlink_configs do
  begin
    run "ln -s #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  rescue
    "File exists"
  end
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require './config/boot'
