module DataSyncer
  class Base
    def import_model_from_yaml(file)
      klass = File.basename(file, '.yml').classify.constantize
      YAML.load_file(file).each do |attrs|
        klass.create(attrs)
      end
    end

    def export_model_to_yaml(klass, file)
      write_content_for_file(
        file,
        generate_yaml_content(klass)
      )
    end

    def write_content_for_file(file_name, content)
      file = File.new file_name, 'a'
      file.puts content
      file.close
    end

    def generate_yaml_content(klass)
      klass.all.map(&:attributes).to_yaml
    end

    def self.choose_syncer(klass)
      if Object.const_defined?("DataSyncer::#{klass.name}Syncer")
        "DataSyncer::#{klass.name}Syncer".constantize
      else
        DataSyncer::Base
      end
    end
  end
end
