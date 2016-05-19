class DataSyncer::DocumentSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    Document.all.map do |document|
      {
        'id' => document.id,
        'name' => document.name,
        'category' => document.category,
        'remote_url' => document.attachment.url(:original),
        'attachment_file_name' => document.attachment_file_name,
        'tag_list' => document.tag_list
      }
    end.to_yaml
  end
end
