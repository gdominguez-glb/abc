package "haproxy"

# start haproxy
service "haproxy" do
  supports [:status, :restart]
  action :start
end

template "/etc/default/haproxy" do
  source "haproxy_default.erb"
end 

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :restart, "service[haproxy]", :delayed
end
