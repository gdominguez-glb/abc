require 'net/sftp'

module Inkling
  class SftpUploader

    INKLING_SFTP_SERVER   = ENV['INKLING_SFTP_SERVER']
    INKLING_SFTP_USERNAME = ENV['INKLING_SFTP_USERNAME']
    INKLING_SFTP_PASSWORD = ENV['INKLING_SFTP_PASSWORD']
    INKLING_SFTP_PATH     = ENV['INKLING_SFTP_PATH']

    def self.upload_and_rename(csv_file_path)
      file_name = File.basename(csv_file_path)
      ip_file_name = file_name.gsub('.csv', '.ip')
      Net::SFTP.start(INKLING_SFTP_SERVER, INKLING_SFTP_USERNAME, password: INKLING_SFTP_PASSWORD) do |sftp|
        sftp.upload!(File.new(csv_file_path, 'r'), "#{INKLING_SFTP_PATH}/#{file_name}")
        sftp.rename!("#{INKLING_SFTP_PATH}/#{file_name}", "#{INKLING_SFTP_PATH}/#{ip_file_name}")
        sftp.rename!("#{INKLING_SFTP_PATH}/#{ip_file_name}", "#{INKLING_SFTP_PATH}/#{file_name}")
      end
    end

    def self.upload(csv_file_path)
      filename = File.basename(csv_file_path)
      Net::SFTP.start(ENV['INKLING_SFTP_SERVER'], ENV['INKLING_SFTP_USERNAME'], password: ENV['INKLING_SFTP_PASSWORD']) do |sftp|
        sftp.upload!(File.new(csv_file_path, 'r'), "#{ENV['INKLING_SFTP_PATH']}/#{filename}")
      end
    end

    def self.rename_file(original_name, new_name)
      Net::SFTP.start(ENV['INKLING_SFTP_SERVER'], ENV['INKLING_SFTP_USERNAME'], password: ENV['INKLING_SFTP_PASSWORD']) do |sftp|
        original_path = "#{ENV['INKLING_SFTP_PATH']}/#{original_name}"
        new_path = "#{ENV['INKLING_SFTP_PATH']}/#{new_name}"
        sftp.rename!(original_path, new_path)
      end
    end

    def self.list_files
      Net::SFTP.start(ENV['INKLING_SFTP_SERVER'], ENV['INKLING_SFTP_USERNAME'], password: ENV['INKLING_SFTP_PASSWORD']) do |sftp|
        sftp.dir.foreach(ENV['INKLING_SFTP_PATH']) do |entry|
          puts entry.inspect
        end
      end
    end
  end
end
