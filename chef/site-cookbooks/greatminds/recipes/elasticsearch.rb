package 'openjdk-7-jre'

remote_file "/home/#{node['user']['name']}/elasticsearch-#{node['elasticsearch']['version']}.deb" do
  source "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}.deb"
  mode 0644
  action :create_if_missing
end

bash "install elasticsearch" do
  cwd "/home/#{node['user']['name']}"
  code <<-EOH
    dpkg -i elasticsearch-#{node['elasticsearch']['version']}.deb
  EOH
  not_if { File.exists?("/usr/share/elasticsearch") && File.exists?("/etc/init.d/elasticsearch") }
end
