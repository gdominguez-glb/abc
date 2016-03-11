class DataSyncer::DocumentImporter
  def self.create(attrs)
    return if Document.find_by(id: attrs['id']).present?
    remote_url = attrs.delete('remote_url')
    Document.create(attrs.merge(attachment: open(remote_url)))
  end
end
