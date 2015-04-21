package "monit"

service "monit" do
  supports restart: true, start: true, reload: true
  action [:enable, :start]
end

template "/etc/monit/conf.d/#{node['app']}" do
  source "monitrc.erb"
  mode 0644
  owner node['user']['name']
  group node['group']
  notifies :reload, "service[monit]", :delayed
end
