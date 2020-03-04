server '34.224.17.52', user: 'deploy', roles: %w{app web}
server '100.27.4.207', user: 'deploy', roles: %w{app web}

server '34.207.62.18', user: 'deploy', roles: %w{search worker}

set :branch, 'feature/dev-environment-for-marketing'
set :rails_env, 'dev'
