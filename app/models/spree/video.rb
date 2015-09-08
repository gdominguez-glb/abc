class Spree::Video < ActiveRecord::Base
  belongs_to :video_group, class_name: 'Spree::VideoGroup'

  validates_presence_of :title

  has_attached_file :file, s3_permissions: :private
  validates_attachment :file, content_type: { content_type: /\A*\Z/ }

  has_many :video_classifications, dependent: :delete_all, inverse_of: :video
  has_many :taxons, through: :video_classifications

  scope :with_taxons, ->(taxons) {
    ids = taxons.map { |taxon| taxon.self_and_descendants.pluck(:id) }.flatten.uniq
    joins(:taxons).where("spree_taxons.id" => ids)
  }

  attr_accessor :video_group_name

  before_save :set_video_group

  after_initialize do
    self.video_group_name = self.video_group.try(:name)
  end

  # after_save :analyze_taxons

  def products
    video_group.try(:products) || []
  end

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

  def post_flush_writes
    WistiaWorker.perform_async(self.id) if self.wistia_id.blank?
  end

  def update_wistia_data(media_data)
    update(
      wistia_id:        media_data['id'],
      wistia_hashed_id: media_data['hashed_id'],
      wistia_status:    media_data['status']
    )
  end

  def categories
    taxons.map(&:taxonomy).uniq.map(&:name)
  end

  def wistia_ready?
    wistia_status == 'ready'
  end

  def s3_url
    self.file.expiring_url(60*60*60)
  end

  private

  def set_video_group
    if self.video_group_name.present?
      self.video_group = Spree::VideoGroup.find_or_create_by(name: self.video_group_name)
    end
  end
end
