class DataSyncer::TaggingImporter
  def self.create(attrs)
    tagging = ActsAsTaggableOn::Tagging.new(attrs)
    tagging.save validate: false
  end
end
