class DataSyncer::PageSyncer < DataSyncer::Base
  def generate_yaml_content
    Page.all.map do |page|
      attrs = page.attributes
      curriculum_id = attrs.delete('curriculum_id')
      if page.tiles.present?
        attrs['tiles'] = convert_urls_in_tiles(page.tiles)
      end
      attrs['curriculum_name'] = Curriculum.find_by(id: curriculum_id).try(:name)
      attrs.to_hash
    end.to_yaml
  end

  def convert_urls_in_tiles(tiles)
    rows = tiles[:rows]
    rows.each do |row|
      row.keys.select{|k| k =~ /link/ }.each do |key|
        if row[key] && row[key].include?('staging.greatminds.org')
          changed = true
          row[key] = row[key].gsub('staging.greatminds.org', 'production.greatminds.org')
        end
      end
    end
    { rows: rows }
  end
end
