# TODO: old stage env IP's
# server '52.91.255.197', user: 'deploy', roles: %w{app web}  server 'stage-0.greatminds.org', user: 'deploy', roles: %w{app web}
# server '18.206.157.16', user: 'deploy', roles: %w{app web}  server 'stage-1.greatminds.org', user: 'deploy', roles: %w{app web}
# server '54.175.200.155', user: 'deploy', roles: %w{search worker}


server 'stage-0.greatminds.org', user: 'deploy', roles: %w{app web}
server 'stage-1.greatminds.org', user: 'deploy', roles: %w{app web}

server 'stage-es.greatminds.org', user: 'deploy', roles: %w{search worker}

set :branch, 'website-redesign-3.1-with-upgrade'
set :rails_env, 'stage'
