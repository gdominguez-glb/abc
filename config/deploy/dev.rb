# frozen_string_literal: true
# 54.81.225.82

server '54.159.14.213', user: 'deploy', roles: %w{web app db search worker}

set :branch, 'feature/upgrade-rails-ruby'
set :rails_env, 'dev'
