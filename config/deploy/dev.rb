# frozen_string_literal: true

server '54.81.225.82', user: 'deploy', roles: %w{web app db search worker}
# server '100.27.4.207', user: 'deploy', roles: %w{app web}

# server '34.207.62.18', user: 'deploy', roles: %w{search worker}

set :branch, 'CDS-1496'
set :rails_env, 'dev'
