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
set :deploy_via, :remote_cache

# set :deploy_via, :checkout

# set :scm_verbose, true
# set :use_sudo, false
# 
# set :deploy_via, :copy
# set :copy_strategy, :export
# set :copy_cache, true
# set :copy_compression, :gzip

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
end

# Bundler
namespace :bundler do
  desc "check_paths"
  task :check_paths, :roles => :app do
    run "echo $PATH"
  end
  desc "Create, clear, symlink the shared bundler_gems path and install Bundler cached gems"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --deployment --without test development"
  end
end

after 'deploy:update_code', 'bundler:check_paths'
after 'deploy:update_code', 'bundler:install'
# after 'deploy:update_code', 'deploy:permissions'