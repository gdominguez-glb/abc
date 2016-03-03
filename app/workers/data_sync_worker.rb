require 'net/ssh'
require 'net/scp'
require 'data_syncer'
require 'fileutils'

class DataSyncWorker
  include Sidekiq::Worker

  def perform
    zip_file_name = "export_models_#{Time.now.to_i}.zip"
    zip_file_path = Rails.root.join('tmp', zip_file_name).to_s
    DataSyncer::Exporter.new(
      models_to_export: [Page, FaqCategory, Question, Job],
      zip_file: zip_file_path
    ).export
    Net::SSH.start('beta.greatminds.org', 'deploy') do |ssh|
      ssh.scp.upload!(zip_file_path, "/var/www/greatminds/current/tmp/", recursive: true, via: :sftp)
      output = ssh.exec!("cd /var/www/greatminds/current && export PATH=/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games && RAILS_ENV=production bundle exec rake sync:import zip_file_path=/var/www/greatminds/current/tmp/#{zip_file_name}")
    end
  end
end
