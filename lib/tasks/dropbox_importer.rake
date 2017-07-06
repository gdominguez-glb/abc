require 'dropbox_api'

namespace :dropbox_importer do

  # how to use this task: https://www.dropbox.com/s/8s5mvml7rw5f6h1/dropbox_tour.mov?dl=0
  desc "Import pdf/materials from dropbox folder"
  task import: :environment do
    CLIENT_ID = 'xb7ktq1kva7srmw'
    CLIENT_SECRET = '7wbhl0qtxlthbbc'

    authenticator = DropboxApi::Authenticator.new(CLIENT_ID, CLIENT_SECRET)
    puts "Open this link in browser to get the auth code: #{authenticator.authorize_url}"
    print "Enter the auth code: "
    code = $stdin.gets.chomp

    print "Enter the folder you want to import: "
    folder = $stdin.gets.chomp

    auth_bearer = authenticator.get_token(code)

    client = DropboxApi::Client.new(auth_bearer.token)
    result = client.list_folder "/Intridea _ Web 2.0 Sandbox (Final Delivery)/#{folder}"

    directory_name = "dropbox_import_#{Time.now.to_i}"
    tmp_directory = Rails.root.join('tmp', directory_name)
    FileUtils.mkdir_p(tmp_directory)

    result.entries.each do |entry|
      zip_file_path = Rails.root.join(tmp_directory, entry.name)
      file = File.new(zip_file_path, 'wb')
      client.download(entry.path_display) do |chunk|
        file.write chunk
      end
      file.close

      product = Spree::Product.find_by(name: entry.name.gsub('.zip', ''))

      if ENV['check'].present?
        puts "#{entry.name.gsub('.zip', '')} Not found in products." if product.nil?
        next
      end

      next if product.nil?

      dest_directory_path = File.join(tmp_directory, product.name)
      FileUtils.mkdir_p(dest_directory_path)

      MaterialZipImporter.new(
        product: product,
        zip_file_path: zip_file_path,
        dest_directory_path: dest_directory_path
      ).import

      puts "Imported: #{entry.name}"
    end

    FileUtils.rm_r tmp_directory

    puts "Yay."
  end
end
