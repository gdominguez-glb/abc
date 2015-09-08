Spree::Product.class_eval do

  belongs_to :video_group, class_name: 'Spree::VideoGroup'

  ## spree bundles
  parts_habtm = select("#{Spree::Product.quoted_table_name}.*")
                  .select("#{Spree::Part.quoted_table_name}.id AS part_id")

  has_and_belongs_to_many :parts, -> { parts_habtm },
                          class_name: 'Spree::Product',
                          join_table: 'spree_parts',
                          foreign_key: 'bundle_id'

  scope :search_can_be_part, lambda { |query|
    where = "LOWER(#{Spree::Product.quoted_table_name}.name) LIKE ?"
    like  = "%#{query.downcase}%"
    available.not_deleted
      .joins(:master)
      .where(can_be_part: true)
      .where(where, like)
      .group('spree_products.id')
      .limit(10)
  }

  scope :excluding_parts, lambda { |parts|
    where.not(id: parts) unless parts.empty?
  }

  scope :saleable, -> { where(for_sale: true) }
  scope :fulfillmentable, -> { where("fulfillment_date < ? or fulfillment_date is null", Time.now) }

  def parts?
    parts.any?
  end

  def variants?
    variants.any?
  end

  def been_purchased?
    if parts?
      # TODO: Make this actually work
      # parts.each { |part| return true if part.been_purchased? }
      false
    else
      orders.where.not(completed_at: nil).any?
    end
  end
  ## end of spree bundles

  unless Spree::Product.respond_to?(:searchkick_options)
    searchkick
  end

  validates :license_length, numericality: { only_integer: true }, allow_blank: true
  validates :redirect_url, format: { with: URI.regexp }, allow_blank: true

  belongs_to :curriculum, class_name: 'Spree::Curriculum'
  belongs_to :grade, class_name: 'Spree::Grade'
  belongs_to :grade_unit, class_name: 'Spree::GradeUnit'

  has_many :materials
  has_many :material_import_jobs
  has_many :download_products
  has_many :download_pages, through: :download_products

  attr_accessor :new_image, :new_digital

  after_create :assign_image_to_master, :assign_digital_to_master, :init_grades_materials

  scope :free, -> {
    joins("join spree_variants on spree_variants.product_id = spree_products.id").
    joins("join spree_prices on spree_prices.variant_id = spree_variants.id").
    where({spree_variants: { deleted_at: nil, is_master: true}}).
    where({spree_prices: { deleted_at: nil, amount: 0 }})
  }

  add_search_scope :in_taxons do |taxons|
    includes(:classifications).
    where("spree_products_taxons.taxon_id" => taxons.map{ |taxon| taxon.self_and_descendants.pluck(:id) }.flatten ).
    order("spree_products_taxons.position ASC")
  end

  if !defined?(PRODUCT_TYPES)
    PRODUCT_TYPES = [
      'Curriculum',
      'Video',
      'Pdf',
      'Other'
    ]
  end

  PRODUCT_TYPES.each do |product_type|
    scope product_type.underscore.pluralize, ->{ where(product_type: product_type) }
  end

  def free?
    price == 0
  end

  def downloadable?
    product_type == 'Pdf'
  end

  def downloadable_url
    digital = digitals.first
    digital.attachment.expiring_url(3600) if digital
  end

  def video_digital
    digitals.first
  end

  def wistia_ready?
    video_digital.try(:wistia_ready?)
  end

  def video_id
    video_digital.try(:wistia_hashed_id)
  end

  def video_s3_url
    video_digital.try(:s3_url)
  end

  def categories
    taxons.map(&:taxonomy).uniq.map(&:name)
  end

  def assign_image_to_master
    self.master.images << Spree::Image.new(attachment: self.new_image) if self.new_image.present?
  end

  def assign_digital_to_master
    self.master.digitals << Spree::Digital.new(attachment: self.new_digital) if self.new_digital.present?
  end

  def init_grades_materials
    if self.is_grades_product?
      GRADE_LEVELS.each do |grade_level|
        self.materials.create(name: grade_level)
      end
    end
  end
end
