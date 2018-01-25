class DataDumper

  MODELS_TO_DUMP = [Page]

  class << self

    def dump
      cmd = nil
      tables = MODELS_TO_DUMP.map {|klass| "-t #{klass.table_name}" }.join(' ')
      with_config do |app, host, db, user, password|
        cmd = "PGPASSWORD=#{password} pg_dump --host #{host} --username #{user} --verbose --data-only #{tables} #{db} > #{Rails.root}/db/#{app}_data.sql"
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
      puts "Done."
    end

    def with_config
      yield Rails.application.class.parent_name.underscore,
            ActiveRecord::Base.connection_config[:host],
            ActiveRecord::Base.connection_config[:database],
            ActiveRecord::Base.connection_config[:username],
            ActiveRecord::Base.connection_config[:password]
    end

  end
end
