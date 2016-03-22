class DataSyncer::TagImporter
  def self.create(attrs)
    taggings = attrs.delete('taggings')
    tag = ActsAsTaggableOn::Tag.create(attrs)
    taggings.each do |tagging_attrs|
      tag.taggings.create(tagging_attrs)
    end
  end
end
