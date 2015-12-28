class DataSyncer::PageImporter
  def self.create(attrs)
    name = attrs.delete('curriculum_name')
    if name.present?
      attrs['curriculum_id'] = Curriculum.find_by(name: name).try(:id)
    end
    Page.create(attrs)
  end
end
