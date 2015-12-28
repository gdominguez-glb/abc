class DataSyncer::PageImporter
  def create(attrs)
    if attrs['curriculum_name'].present?
      attrs['curriculum_id'] = Curriculum.find_by(name: attrs['curriculum_name']).try(:id)
    end
    Page.create(attrs)
  end
end
