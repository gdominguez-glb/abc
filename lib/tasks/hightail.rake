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

  desc "import from zip file directly"
  task import_from_file: :environment do
    zip_file_path = ENV['file']
    if File.exists?(zip_file_path)
      product = Spree::Product.find_by(name: File.basename(zip_file_path).gsub('.zip', ''))
      if product.nil?
        puts "Can't find product for the zip file"
        return
      end
      puts "import materials for #{product.name}"
      directory_name = "hightail_import_#{Time.now.to_i}"
      tmp_directory = Rails.root.join('tmp', directory_name)
      dest_directory_path = File.join(tmp_directory, product.name)
      FileUtils.mkdir_p(dest_directory_path)

      MaterialZipImporter.new(
        product: product,
        zip_file_path: zip_file_path,
        dest_directory_path: dest_directory_path
      ).import
    end
  end
end
