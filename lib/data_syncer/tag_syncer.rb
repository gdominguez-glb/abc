class DataSyncer::TagSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    ActsAsTaggableOn::Tag.all.map do |tag|
      tag.attributes.merge({
        'taggings' => tag.taggings.map(&:attributes)
      })
    end.to_yaml
  end
end
