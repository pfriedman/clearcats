# developer machine will log in with netid to server (i.e. clinical-rails-stg.bioinformatics.northwestern.edu.)
# developer machine will also log in with netid to code.nubic.northwestern.edu to do a git ls-remote to resolve branch/tag to commit hash
# server will log in with the same netid and check out from code.nubic.northwestern.edu/git/faculty-resource-bank.git

# add the following lines to your ~/.ssh/config, replacing xyz123 with your netid
# Host clinical-rails-stg*
# Hostname clinical-rails-stg.bioinformatics.northwestern.edu
# User xyz123
#
# Host code*
# Hostname code.bioinformatics.northwestern.edu
# User xyz123

# require "bundler/capistrano"

set :deploy_via, :checkout
set :scm_verbose, true
set :use_sudo, false
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_cache, true
set :copy_compression, :gzip

set :runner, nil
set :use_sudo, false
set :application, 'clearcats'
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_environment['PATH'] = "/opt/ruby-enterprise/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin"

# Version control
default_run_options[:pty] = true # to get the passphrase prompt from git
set :scm, "git"
set :repository, "ssh://code.bioinformatics.northwestern.edu/git/#{application}.git"

set :branch, "master"
set :deploy_to, "/var/www/apps/#{application}"
# set :deploy_via, :remote_cache

# Roles
task :set_roles do
  role :app, app_server
  role :web, app_server
  role :db, app_server, :primary => true
end

# Staging environment
desc "Deploy to staging"
task :staging do
  set :app_server, "clinical-rails-stg.bioinformatics.northwestern.edu"
  set :rails_env, "staging"
  default_environment['ORACLE_HOME'] = '/usr/lib/oracle/10.2.0.4/client64'
  default_environment['LD_LIBRARY_PATH'] = '/usr/lib/oracle/10.2.0.4/client64/lib:/lib:/usr/lib:/usr/local/lib'
  set_roles
end

# Production environment
desc "Deploy to production"
task :production do
  set :app_server, "clinical-rails-prod.bioinformatics.northwestern.edu"
  set :rails_env, "production"
  default_environment['ORACLE_HOME'] = '/usr/lib/oracle/10.2.0.4/client64'
  default_environment['LD_LIBRARY_PATH'] = '/usr/lib/oracle/10.2.0.4/client64/lib:/lib:/usr/lib:/usr/local/lib'
  set_roles
end

# Deploy start/stop/restart
namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  desc "Fix permissions"
  task :permissions do
    sudo "chmod -R g+w #{shared_path} #{current_path}"
  end
  
  desc "Remove certain files that should not be deployed - should find way to not deploy them in the first place" 
  task :remove_files do
    ["cucumber", "rcov", "ci"].each do |rake|
      run "cd #{release_path} && rm lib/tasks/#{rake}.rake"
    end
  end
end

after 'deploy:update_code', 'deploy:remove_files'
after 'deploy:update_code', 'deploy:permissions'