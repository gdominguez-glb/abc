class Spree::Video < ActiveRecord::Base

  searchkick callbacks: :async

  def search_data
    {
      title: title,
      description: description,
      user_ids: [-1]
    }
  end

  belongs_to :video_group, class_name: 'Spree::VideoGroup'

  validates_presence_of :title

  has_attached_file :file, s3_permissions: :private
  validates_attachment :file, content_type: { content_type: /\A*\Z/ }

  has_many :video_classifications, dependent: :delete_all, inverse_of: :video
  has_many :taxons, through: :video_classifications

  scope :with_taxons, ->(taxons) {
    joins(:taxons).where("spree_taxons.id" => taxons.map(&:id))
  }

  attr_accessor :video_group_name

  before_save :set_video_group

  after_save :assign_free_taxons

  after_initialize do
    self.video_group_name = self.video_group.try(:name) if self.respond_to?(:video_group_id)
  end

  after_commit :run_wistia_worker, on: :create

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

  def run_wistia_worker
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

  def assign_free_taxons
    free_taxon    = Spree::Taxon.find_by(name: 'Free')
    premium_taxon = Spree::Taxon.find_by(name: 'Premium')
    return if free_taxon.nil? && premium_taxon.nil?
    if self.is_free?
      self.taxons << free_taxon
      self.taxons.destroy(premium_taxon)
    else
      self.taxons << premium_taxon
      self.taxons.destroy(free_taxon)
    end
  end
end
