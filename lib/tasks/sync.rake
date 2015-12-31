require 'data_syncer'

namespace :sync do
  desc "run sync import task"
  task import: :environment do
    zip_file_path = ENV['zip_file_path']
    if File.exists?(zip_file_path)
      DataSyncer::Importer.new(zip_file_path).import
    end
  end
end
