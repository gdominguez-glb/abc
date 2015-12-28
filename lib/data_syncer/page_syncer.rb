class DataSyncer::PageSyncer < DataSyncer::Base
  def generate_yaml_content
    Page.all.each do |page|
      attrs = page.attributes
      curriculum_id = attrs.delete('curriculum_id')
      attrs['curriculum_name'] = Curriculum.find_by(id: curriculum_id).try(:name)
      attrs
    end.to_yaml
  end
end
