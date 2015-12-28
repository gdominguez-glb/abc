require 'fileutils'
require 'zip/zip'
require 'find'

module DataSyncer
  class Importer

    def initialize(zip_file_path)
      @zip_file_path = zip_file_path
      @temp_import_directory = Rails.root.join('tmp', "tmp_sync_import_#{Time.now.to_i}")
    end

    def import
      FileUtils.mkdir_p(@temp_import_directory)
      extract_zip_file
      import_models_from_directory
    end

    def extract_zip_file
      Zip::ZipFile.open(@zip_file_path) do |zip_file|
        zip_file.each do |entry|
          file_path= File.join(@temp_import_directory, entry.name.downcase)
          FileUtils.mkdir_p(File.dirname(file_path))
          zip_file.extract(entry, file_path) unless File.exist?(file_path)
          puts "Extracting #{entry.name.downcase}"
        end
      end
    end

    def import_models_from_directory
      Find.find(@temp_import_directory).each do |path|
        if File.basename(path).end_with?('.yml')
          import_model_from_yaml_file(path)
        end
      end
    end

    def import_model_from_yaml_file(file_path)
      klass = File.basename(file_path).split('.').first.classify
      klass.transaction do
        klass.destroy_all
        YAML.load_file(file_path).each do |attrs|
          choose_klass_importer(klass).create(attrs)
        end
      end
    end

    def choose_klass_importer(klass)
      if Object.const_defined?("DataSyncer::#{klass.name}Importer")
        "DataSyncer::#{klass.name}Importer".constantize
      else
        klass
      end
    end

  end
end
