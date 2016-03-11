class DataSyncer::DocumentSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    Document.all.map do |document|
      {
        id: document.id,
        name: document.name,
        category: document.category,
        remote_url: document.attachment.url(:original)
      }
    end.to_yaml
  end
end
