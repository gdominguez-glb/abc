Spree::Product.class_eval do
  include SalesforceAccess

  def self.sobject_name
    'PricebookEntry'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(sf_id_pricebook: sfo.Pricebook2Id,
                    sf_id_product: sfo.Product2Id,
                    price: sfo.UnitPrice)
    sfo_data
  end

  def self.matches_salesforce_object(sfo)
    matches = super(sfo)
    return matches if matches.present?
    return none if sfo.Pricebook2Id.blank? || sfo.Product2Id.blank?
    where sf_id_pricebook: sfo.Pricebook2Id, sf_id_product: sfo.Product2Id
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end

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
  scope :fulfillmentable, -> { where("spree_products.fulfillment_date < ? or spree_products.fulfillment_date is null", Time.now) }
  scope :unexpire, -> { where("spree_products.expiration_date > ? or spree_products.expiration_date is null", Time.now) }

  after_save :add_video_group_taxon

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

  attr_accessor :new_image

  after_create :assign_image_to_master, :init_grades_materials

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
      'Digital',
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

  def digital?
    product_type == 'Digital'
  end

  def assign_image_to_master
    self.master.images << Spree::Image.new(attachment: self.new_image) if self.new_image.present?
  end

  def init_grades_materials
    if self.is_grades_product?
      GRADE_LEVELS.each do |grade_level|
        self.materials.create(name: grade_level)
      end
    end
  end

  def add_video_group_taxon
    if self.video_group
      taxon = Spree::Taxon.find_by(name: self.video_group.name)
      self.taxons << taxon if taxon
    end
  end
end
