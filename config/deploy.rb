# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'greatminds'
set :repo_url, 'git@github.com:intridea/greatminds.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/greatminds'


set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.6'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, false

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

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task "unicorn_#{command}" do
      on roles(:web) do
        as :deploy do
          execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
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

after "deploy:finished", 'deploy:unicorn_restart'
after "deploy:finished", 'sidekiq:restart'
after "deploy:finished", 'deploy:sitemap:create'
