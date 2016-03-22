class DataSyncer::DocumentImporter
  def self.create(attrs)
    return if Document.find_by(id: attrs['id']).present?
    remote_url           = attrs.delete('remote_url')
    attachment_file_name = attrs.delete('attachment_file_name')

    document = Document.new(attrs.merge(attachment: open(remote_url)))
    document.attachment_file_name = attachment_file_name
    document.save
  end
end
