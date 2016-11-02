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
      begin
        import_video(row)
      rescue => e
        puts "Failed to import video:"
        puts row.inspect
        puts e.message.inspect
        puts e.backtrace.join("\n").inspect
      end
      count += 1
    end
    puts
    puts "imported #{count} videos."
  end

  def import_video(row)
    print '.'

    title            = row['Video Title']
    vimeo_id         = row['Vimeo URL'].split('/').last
    custom_order     = row['Order']

    video = Spree::Video.find_or_initialize_by(vimeo_id: vimeo_id)
    video.title        = title
    video.custom_order = custom_order
    if video.new_record?
      download_url = GmVimeo.new.download_url_of_video(vimeo_id)
      video.file = open(download_url, allow_redirections: :all)
    end
    video.save

    assign_taxons_to_video(video, row)
    assign_video_group(video)
  end

  def assign_taxons_to_video(video, row)
    taxon_headers = row.headers.reject(&:blank?) - ['Video Title', 'Vimeo URL', 'Order']
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

  def assign_video_group(video)
    group_taxonomy = Spree::Taxonomy.find_by(name: 'Type')
    return if group_taxonomy.nil?
    video_group_name = video.taxons.where(id: group_taxonomy.taxons.pluck(:id)).first.try(:name)
    video.update(video_group_name: video_group_name) if video_group_name
  end
end
