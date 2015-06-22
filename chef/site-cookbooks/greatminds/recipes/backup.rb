# install backup gem within rbenv
bash 'install backup' do
  user node['user']['name']
  cwd "/home/#{node['user']['name']}"
  code <<-EOH
    export HOME=/home/#{node['user']['name']}
    export RBENV_ROOT="${HOME}/.rbenv"
    export PATH="${RBENV_ROOT}/bin:${PATH}"
    rbenv init -
    .rbenv/bin/rbenv exec gem install backup
    rbenv rehash
  EOH
end

directory "/home/deploy/Backup" do
  user node['user']['name']
  group node['group']
  mode 0755
end

directory "/home/deploy/Backup/models" do
  user node['user']['name']
  group node['group']
  mode 0755
end

# create Backup config.rb
template "/home/deploy/Backup/config.rb" do
  source "backup_config.rb.erb"
  mode 0640
  owner node['user']['name']
  group node['group']
end
#
# create Backup file
template "/home/deploy/Backup/models/db_backup.rb" do
  source "db_backup.rb.erb"
  mode 0640
  owner node['user']['name']
  group node['group']
end
