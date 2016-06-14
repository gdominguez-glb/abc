class DataSyncer::DocumentImporter
  def self.create(attrs)
    return if Document.find_by(id: attrs['id']).present?
    Document.create(attrs)
  end
end
