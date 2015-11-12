require 'zipper'

module DataSyncer
  class Exporter
    def initialize(attrs={})
      @models_to_export = attrs[:models_to_export]
      @zip_file         = attrs[:zip_file]
      @timestamp        = Time.now.to_i
      @sync_dir_path    = Rails.root.join('tmp', "sync_export", "sync_export_#{@timestamp}")
    end

    def export
      FileUtils.mkdir_p(@sync_dir_path)
      @models_to_export.each do |klass|
        DataSyncer::Base.new.export_model_to_yaml(klass, model_yaml_file_name(klass))
      end
      Zipper.zip(@sync_dir_path, @zip_file)
    end

    def model_yaml_file_name(klass)
      File.join(@sync_dir_path, "#{klass.table_name}.yml")
    end
  end
end
