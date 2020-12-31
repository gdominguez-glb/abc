server 'stage-0.greatminds.org', user: 'deploy', roles: %w{app web}
server 'stage-1.greatminds.org', user: 'deploy', roles: %w{app web}

server 'stage-es.greatminds.org', user: 'deploy', roles: %w{search worker}

set :branch, 'feature/upgrade-rails-ruby'
set :rails_env, 'stage'
