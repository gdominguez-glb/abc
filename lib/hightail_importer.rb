require 'hightail'
require 'material_zip_importer'

class HightailImporter
  attr_accessor :hightail_client, :tmp_directory, :folder_id, :zip_files_info

  def initialize(folder_id)
    @folder_id       = folder_id
    @zip_files_info    = []
    @hightail_client = Hightail::Client.instance
  end

  def import
    fetch_file_ids
    create_temp_directory
    download_zip_files
    remove_temp_directory
  end

  def fetch_file_ids
    folder_info = hightail_client.folder_info(folder_id)
    folder_info['files']['file'].each do |file_info|
      if file_info['name'].end_with?('.zip')
        @zip_files_info << file_info
      end
    end
  end

  def create_temp_directory
    directory_name = "hightail_import_#{Time.now.to_i}"
    @tmp_directory = Rails.root.join('tmp', directory_name)
    FileUtils.mkdir_p(@tmp_directory)
  end

  def remove_temp_directory
    FileUtils.rm_rf(tmp_directory)
  end

  def download_zip_files
    @zip_files_info.each do |file_info|
      product_name = file_info['name'].gsub(/v\d+\.zip$/, '').strip
      product = Spree::Product.find_by(name: product_name)
      download_zip_file(product, file_info) if product
    end
  end

  def download_zip_file(product, file_info)
    zip_file_path = File.join(tmp_directory, file_info['name'])
    hightail_client.download_file(file_info['id'], zip_file_path)
    dest_directory_path = File.join(tmp_directory, product.name)
    FileUtils.mkdir_p(dest_directory_path)

    MaterialZipImporter.new(
      product: product,
      zip_file_path: zip_file_path,
      dest_directory_path: dest_directory_path
    ).import
  end
end
