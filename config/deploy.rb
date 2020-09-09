# config valid only for current version of Capistrano
lock '3.14.1'

set :application, 'greatminds'
set :repo_url,    'git@github.com:greatmindsorg/greatminds.git'
set :user,        'deploy'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/greatminds'


set :rbenv_ruby, '2.6.3'
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} /usr/local/rbenv/bin/rbenv exec"

set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             false
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma_#{fetch(:application)}.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_env,        'dev'
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
# Change to false when not using ActiveRecord
set :puma_init_active_record, true

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/download_jobs', 'tmp/download_job_zips', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :sidekiq_role, :worker
set :sidekiq_concurrency, 3

set :whenever_identifier, ->{ "#{fetch(:application)}" }
set :whenever_roles, [:worker]

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:puma_restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :puma_restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc "clear pagespeed cache"
  task :clear_pagespeed_cache do
    on roles(:web) do
      as :deploy do
        begin
          execute 'if test -d /var/ngx_pagespeed_cache/; then sudo touch /var/ngx_pagespeed_cache/cache.flush; fi;'
        rescue
          puts 'Fail to clear pagespeed cache'
        end
      end
    end
  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     within release_path do
  #     end
  #   end
  # end

  # example: cap qa deploy:invoke task=db:migrate
  desc "Invoke rake task"
  task :invoke do
    on roles(:web) do
      within "#{deploy_to}/current" do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end
end

after 'deploy:finished', 'deploy:puma_restart'
after 'deploy:finished', 'sidekiq:restart'
after 'deploy:finished', 'sitemap:create'
after 'deploy:finished', 'deploy:clear_pagespeed_cache'
