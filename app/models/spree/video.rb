class Spree::Video < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'

  validates_presence_of :title

  has_attached_file :file, s3_permissions: :private, s3_headers: { "Content-Disposition" => "attachment" }
  validates_attachment :file, content_type: { content_type: /\A*\Z/ }

  has_many :video_classifications, dependent: :delete_all, inverse_of: :video
  has_many :taxons, through: :video_classifications

  after_save :analyze_taxons

  def analyze_taxons
    title = self.title.gsub('_', ' ')

    if title =~ /GPKM(\d+) T(.*) L(\d+)/
      matches = title.scan(/GPKM(\d+) T(.*) L(\d+)/)[0]
      assign_taxons('Pre-K', matches[0], matches[1], matches[2])
    elsif title =~ /G(\d+)M(\d+) T(.*) L(\d+)/
      matches = title.scan(/G(\d+)M(\d+) T(.*) L(\d+)/)[0]
      assign_taxons(matches[0], matches[1], matches[2], matches[3])
    end
  end

  def assign_taxons(grade, _module, topic, lesson)
    assign_taxon_within_taxonomy('Grade', grade)
    assign_taxon_within_taxonomy('Module', _module)
    assign_taxon_within_taxonomy('Topic', topic)
    assign_taxon_within_taxonomy('Lesson', lesson)
  end

  def assign_taxon_within_taxonomy(taxonomy_name, taxon_name)
    if (taxonomy = Spree::Taxonomy.find_by(name: taxonomy_name)) && (taxon = taxonomy.taxons.find_by(name: taxon_name))
      self.taxons << taxon
    end
  end
end
