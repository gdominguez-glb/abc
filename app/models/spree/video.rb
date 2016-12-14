class Spree::Video < ActiveRecord::Base
  include Taxonable

  has_attached_file :screenshot, {
    path:           "/:class/:attachment/:id_partition/:style/:filename",
    url:            ":s3_alias_url",
    s3_protocol:    "https",
    s3_host_alias:  ENV['s3_bucket_name'],
    :styles => {
      :medium => "330x220" }
  }

  searchkick callbacks: :async

  def search_data
    {
      title: title,
      description: description,
      user_ids: find_user_ids_to_index
    }
  end

  def find_user_ids_to_index
    return [-1] if self.is_free?
    return [] if video_group.nil?
    product_ids = video_group.products.pluck(:id)
    group_ids = Spree::GroupItem.where(product_id: video_group.products.pluck(:id)).pluck(:group_id)
    Spree::LicensedProduct.available.where(product_id: product_ids+group_ids).pluck(:user_id).uniq
  end

  belongs_to :video_group, class_name: 'Spree::VideoGroup'

  validates_presence_of :title

  has_attached_file :file, s3_permissions: :private
  validates_attachment :file, content_type: { content_type: 'video/mp4' }

  has_many :video_classifications, dependent: :delete_all, inverse_of: :video
  has_many :taxons, through: :video_classifications

  attr_accessor :video_group_name

  before_save :set_video_group, :analyze_orders

  after_save :assign_free_taxons

  after_initialize do
    self.video_group_name = self.video_group.try(:name) if self.respond_to?(:video_group_id)
  end

  after_commit :run_wistia_worker, on: :create

  def products
    video_group.try(:products) || []
  end

  def products_to_buy
    (video_group.try(:products) || []).map do |product|
      product.individual_sale? ? product : product.parent_bundle
    end.compact.flatten
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

  def taxonomies
    taxons.map(&:taxonomy).uniq.compact
  end

  def categories
    taxonomies.map(&:name)
  end

  def wistia_ready?
    wistia_status == 'ready'
  end

  def s3_url
    self.file.expiring_url(60*60*60)
  end

  def type_taxon_name
    taxons.joins(:taxonomy).where(spree_taxonomies: { name: 'Type' }).first.name rescue nil
  end

  private

  def set_video_group
    if self.video_group_name.present?
      self.video_group = Spree::VideoGroup.find_or_create_by(name: self.video_group_name)
    end
  end

  def assign_free_taxons
    free_taxon    = Spree::Taxon.find_by(name: 'Free')
    paid_taxon = Spree::Taxon.find_by(name: 'Paid')
    return if free_taxon.nil? && paid_taxon.nil?
    if self.is_free?
      assign_taxon(free_taxon)
      self.taxons.destroy(paid_taxon)
    else
      assign_taxon(paid_taxon)
      self.taxons.destroy(free_taxon)
    end
  end

  def assign_taxon(taxon)
    self.taxons << taxon unless self.taxons.where(name: taxon.name).exists?
  end

  def analyze_orders
    if self.title =~ /G(P?K||\d+) M(\d+) Lessons (\d+)\-(\d+)/ || self.title =~ /G(P?K|\d+)[\ |-]?M(\d+)[\ |-]?L?(\d+)?/
      # GK M3 Lessons 25-32
      # GK-M4-L2, G2M2L9, GPK-M1-L18, GPK M3 Assessments
      self.grade_order, self.module_order, self.lesson_order = revise_grade_order_value($1), $2, $3
    elsif self.title =~ /Grades (\d+)-(\d+)/
      # Grades 3-5
      self.grade_order = revise_grade_order_value($1)
    end
  end

  def revise_grade_order_value(grade_name)
    return 0 if grade_name == 'PK'
    (grade_name.to_i + 1)
  end
end
