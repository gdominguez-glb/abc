class DataSyncer::PageImporter
  def self.create(attrs)
    page = Page.find_or_initialize_by(id: attrs['id'])
    name = attrs.delete('curriculum_name')
    if name.present?
      attrs['curriculum_id'] = Curriculum.find_by(name: name).try(:id)
    end
    page.update(attrs)
  end
end
