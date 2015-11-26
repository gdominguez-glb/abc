require "open-uri"
require 'open_uri_redirections'
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
      file: open(download_url, allow_redirections: :all)
    )

    assign_taxons_to_video(video, row)
  end

  def assign_taxons_to_video(video, row)
    assign_taxons(video, 'Group', [video.video_group.try(:name)])

    taxon_headers = row.headers - ['Video Title', 'Vimeo URL', 'Group']
    taxon_headers.each do |taxon_header|
      taxonomy_name = taxon_header.gsub(/(\ [A-Z]{1,2}$)/, '').strip
      assign_taxons(video, taxonomy_name, [row[taxon_header]]) if [row[taxon_header]].compact.present?
    end
  end

  def assign_taxons(video, taxonomy_name, taxon_names)
    taxonomy = Spree::Taxonomy.find_or_create_by(name: taxonomy_name)
    taxon_names.compact.map(&:strip).each do |taxon_name|
      taxon = taxonomy.taxons.find_or_create_by(name: taxon_name, parent: taxonomy.root)
      begin
        video.taxons << taxon
      rescue
      end
    end
  end
end
