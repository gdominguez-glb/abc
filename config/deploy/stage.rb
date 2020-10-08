server '52.91.255.197', user: 'deploy', roles: %w{app web}
server '18.206.157.16', user: 'deploy', roles: %w{app web}

server '54.175.200.155', user: 'deploy', roles: %w{search worker}

set :branch, 'feature/website-redesign'
set :rails_env, 'stage'
