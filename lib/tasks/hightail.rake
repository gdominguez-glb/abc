require 'hightail_importer'

namespace :hightail do
  desc "import zips from higtail"
  task import: :environment do
    folder_id = ENV['folder_id']
    if folder_id.blank?
      puts "please specify folder_id."
      return
    end
    HightailImporter.new(folder_id).import
  end
end
