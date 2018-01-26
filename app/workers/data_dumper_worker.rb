require 'data_dumper'
class DataDumperWorker
  include Sidekiq::Worker

  def perform
    file_path = Rails.root.join('tmp', "#{Rails.env}_data_dumper_#{Time.now.to_i}.sql")
    DataDumper.dump(file_path)
  end
end
