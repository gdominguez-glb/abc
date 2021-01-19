require 'aws-sdk-s3'

class DataDumper

  ACCESS_TOKEN = 'f4321ec0e619ce04b180124f78be'

  MODELS_TO_DUMP = [Page, FooterLink, FooterTitle, Staff, InTheNew]

  S3_FILES = [ [Staff, :picture] ]

  class << self

    def dump(file_path)
      cmd = nil
      tables = MODELS_TO_DUMP.map {|klass| "-t #{klass.table_name}" }.join(' ')
      with_config do |app, host, db, user, password|
        cmd = "PGPASSWORD=#{password} pg_dump --host #{host} --username #{user} --verbose --data-only #{tables} #{db} > #{file_path}"
      end
      puts cmd
      `#{cmd}`
    end

    def restore(dump_file_path)
      if !File.exists?(dump_file_path)
        puts "File #{dump_file_path} not exists."
        return
      end
      Page.transaction do
        puts "Deleting data before load dump"
        MODELS_TO_DUMP.each do |klass|
          klass.delete_all
        end
      end
      cmd = nil
      with_config do |app, host, db, user, password|
        cmd = "PGPASSWORD=#{password} psql --username #{user} --host #{host} --dbname=#{db}  < #{dump_file_path}"
      end
      `#{cmd}`

      copy_s3_files

      puts "Done."
    end

    def copy_s3_files
      puts "Start to copy s3 files from production to staging."
      S3_FILES.each do |klass_field|
        klass, field = klass_field
        klass.each do |record|
          path = record.send(field).send(:path)
          copy_s3_file(path)
        end
      end
      puts "Finished copy s3 files."
    end

    def with_config
      yield Rails.application.class.parent_name.underscore,
            ApplicationRecord.connection_config[:host],
            ApplicationRecord.connection_config[:database],
            ApplicationRecord.connection_config[:username],
            ApplicationRecord.connection_config[:password]
    end

    def copy_s3_file(file_path)
      AWS.config(
        :access_key_id => ENV['aws_access_key_id'],
        :secret_access_key => ENV['aws_secret_access_key'],
        :max_retries => 3
      )

      bucket_from_info = {:name => 's3.greatminds.org', :endpoint => 's3.amazonaws.com'}
      bucket_to_info = {:name => 's3-staging.greatminds.org',   :endpoint => 's3.amazonaws.com'}

      s3_interface_from = AWS::S3.new(:s3_endpoint => bucket_from_info[:endpoint])
      bucket_from       = s3_interface_from.buckets[bucket_from_info[:name]]

      s3_interface_to   = AWS::S3.new(:s3_endpoint => bucket_to_info[:endpoint])
      bucket_to         = s3_interface_to.buckets[bucket_to_info[:name]]
      bucket_to.objects[file_path].copy_from(file_path, {:bucket => bucket_from})
    end
  end
end
