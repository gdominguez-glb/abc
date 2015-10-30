require "open-uri"
require 'gm_vimeo'

class VimeoImporter
  attr_accessor :csv_path

  def initialize(csv_path)
    @csv_path = csv_path
  end

  def import
    puts 'start importing videos...'
    count = 0
    CSV.foreach(csv_path, encoding: 'ISO-8859-1', headers: true) do |row|
      next if row['Vimeo URL'].blank?
      import_video(row)
      count += 1
    end
    puts
    puts "imported #{count} videos."
  end

  def import_video(row)
    print '.'

    title            = row['Video Title']
    vimeo_id         = row['Vimeo URL'].split('/').last
    video_group_name = row['Group']

    download_url = GmVimeo.new.download_url_of_video(vimeo_id)

    video = Spree::Video.find_or_initialize_by(vimeo_id: vimeo_id)
    video.update(
      title: title,
      video_group_name: video_group_name,
      file: open(download_url)
    )

    assign_taxons_to_video(video, row)
  end

  def assign_taxons_to_video(video, row)
    grades      = ['A', 'B', 'C'].map{|c| row["Grade #{c}"] }.reject(&:blank?)
    grade_bands = ['A', 'B', 'C', 'D'].map{|c| row["Grade Band #{c}"] }.reject(&:blank?)
    modules     = ['A', 'B', 'C'].map{|c| row["Module #{c}"] }.reject(&:blank?)
    lessons     = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'].map{|c| row["Lesson #{c}"] }.reject(&:blank?)

    assign_taxons(video, 'Grade', grades)
    assign_taxons(video, 'Grade Band', grade_bands)
    assign_taxons(video, 'Module', modules)
    assign_taxons(video, 'Lesson', lessons)
  end

  def assign_taxons(video, taxonomy_name, taxon_names)
    taxonomy = Spree::Taxonomy.find_by(name: taxonomy_name)
    taxon_names.each do |taxon_name|
      taxon = taxonomy.taxons.find_or_create_by(name: taxon_name)
      begin
        video.taxons << taxon
      rescue
      end
    end
  end
end
