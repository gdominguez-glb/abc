require 'inkling/csv_generator'
require 'inkling/sftp_uploader'

module Inkling
  def self.onboard(user, licenses)
    user_csv = Inkling::CsvGenerator.generate(user, licenses)
    file_path = generate_csv_file(user, user_csv)
    Inkling::SftpUploader.upload_and_rename(file_path)
  end

  def self.generate_csv_file(user, user_csv)
    csv_file_path = Rails.root.join('tmp', "greatminds_#{user.id}.csv")
    file = File.new(csv_file_path, 'w')
    file.write user_csv
    file.close
    csv_file_path
  end
end
