require 'vimeo_importer'

namespace :vimeo do
  desc 'import vimeo videos from csv'
  task import: :environment do
    csv_path = ENV['csv']
    VimeoImporter.new(csv_path).import
  end
end
