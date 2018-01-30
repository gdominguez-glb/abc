require 'data_dumper'
require 'httparty'

class DataDumperWorker
  include Sidekiq::Worker

  def perform
    file_path = Rails.root.join('tmp', "#{Rails.env}_data_dumper_#{Time.now.to_i}.sql")
    DataDumper.dump(file_path)

    staging_sync_api = "https://staging.greatminds.org/api/data/sync"
    RestClient.post(
      staging_sync_api, {
        access_token: DataDumper::ACCESS_TOKEN,
        dump_file: File.new(file_path, 'rb')
      })
  end
end
