package "nginx"

# remove default nginx config
default_path = "/etc/nginx/sites-enabled/default"
execute "rm -f #{default_path}" do
  only_if { File.exists?(default_path) }
end

# start nginx
service "nginx" do
  supports [:status, :restart]
  action :start
end

# set custom nginx config
template "/etc/nginx/sites-enabled/#{node['app']}" do
  source "nginx_server.conf.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[nginx]", :delayed
end
