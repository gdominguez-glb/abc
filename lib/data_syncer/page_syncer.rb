class DataSyncer::PageSyncer < DataSyncer::Base
  def generate_yaml_content(klass)
    Page.all.map do |page|
      attrs = page.attributes
      curriculum_id = attrs.delete('curriculum_id')
      attrs['body'] = convert_urls_in_content(page.body)
      attrs['curriculum_name'] = Curriculum.find_by(id: curriculum_id).try(:name)
      attrs.to_hash
    end.to_yaml
  end

  def convert_urls_in_tiles(tiles)
    rows = tiles[:rows]
    rows.each do |row|
      row.keys.select{|k| k =~ /link|url/ }.each do |key|
        next if row[key].blank?
        if row[key].include?('staging.greatminds.org') && row[key] !~ /s3-staging\.greatminds\.org/
          row[key] = row[key].gsub('staging.greatminds.org', 'greatminds.org')
        end
        if row[key].include?('s3-staging.greatminds.org')
          row[key] = row[key].gsub('s3-staging.greatminds.org', 's3.greatminds.org')
        end
      end
    end
    { rows: rows }
  end

end
