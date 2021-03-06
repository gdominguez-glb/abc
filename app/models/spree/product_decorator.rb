Spree::Product.class_eval do
  include SalesforceAccess
  include Taxonable

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

  # Provides a means to bypass creation in Salesforce.  For example, this is
  # used to prevent the creation in Salesforce of a record created locally from
  # Salesforce
  def should_create_salesforce?
    false
  end

  belongs_to :video_group, class_name: 'Spree::VideoGroup'
  has_one :inkling_code, class_name: 'Spree::InklingCode'
  has_and_belongs_to_many :grades, class_name: 'Spree::Grade', join_table: :spree_grades_products
  has_many :activities, as: :item

  ## spree bundles
  parts_habtm = select("#{Spree::Product.quoted_table_name}.*")
                  .select("#{Spree::Part.quoted_table_name}.id AS part_id")

  has_many :raw_parts, class_name: 'Spree::Part', foreign_key: :bundle_id

  has_and_belongs_to_many :parts, -> { parts_habtm },
                          class_name: 'Spree::Product',
                          join_table: 'spree_parts',
                          foreign_key: 'bundle_id'

  ## spree group_items
  group_items_habtm = select("#{Spree::Product.quoted_table_name}.*")
                  .select("#{Spree::GroupItem.quoted_table_name}.id AS group_item_id").order("#{Spree::GroupItem.quoted_table_name}.position asc")
  has_and_belongs_to_many :group_items, -> { group_items_habtm },
                          class_name: 'Spree::Product',
                          join_table: 'spree_group_items',
                          foreign_key: 'group_id'

  has_many :materials
  has_many :material_import_jobs
  has_many :download_products
  has_many :download_pages, through: :download_products
  has_many :library_leafs, -> { order(:position) }
  has_many :library_items, through: :library_leafs
  has_many :flipbook_leafs, -> { order(:position) }
  has_many :flipbook_items, through: :flipbook_leafs

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
  scope :show_in_storefront, -> { where(show_in_storefront: true).order('position asc') }
  scope :salesforceable, -> { where.not(sf_id_product: [nil, ''])}
  scope :unarchive, -> { where(archived: false) }
  scope :sort_group_first, -> { order("case product_type when 'group' then 1 else 2 end").order('position asc') }
  scope :search_by_text, ->(q) { where("spree_products.name ilike :q or spree_products.short_description ilike :q or spree_products.meta_text ilike :q", q: "%#{q}%") if q.present? }
  scope :publicable, -> { where("spree_products.can_be_part = ? or spree_products.individual_sale = ? or spree_products.show_in_storefront = ? or spree_products.auto_add_on_sign_up = ?", true, true, true, true) }

  after_save :update_meta_text
  after_save :add_video_group_taxon

  def parts?
    parts.any?
  end

  def has_group_items?
    group_items.any?
  end

  def group_product?
    self.product_type == 'group'
  end

  def free_group_product?
    group_product? && self.group_items.map(&:free?).all?
  end

  def partner_product?
    self.product_type == 'partner'
  end

  def get_in_touch_product?
    self.product_type == 'get_in_touch'
  end

  def library_product?
    self.product_type == 'library'
  end

  def flipbook_product?
    product_type == 'flipbook'
  end

  def inkling_connect_product?
    self.product_type == 'inkling_connect'
  end

  def no_price?
    get_in_touch_product? || group_product? || partner_product?
  end

  validates :access_url, format: { with: URI.regexp }, allow_blank: true
  validates :redirect_url, format: { with: URI.regexp }, allow_blank: true
  validates :learn_more_url, format: { with: URI.regexp }, allow_blank: true
  validates :sf_id_product, :sf_id_pricebook, presence: true, unless: :free?
  validates :sf_id_product, uniqueness: { scope: [:sf_id_pricebook, :deleted_at] },
                            allow_blank: true
  validates :sf_id_product, :sf_id_pricebook,
            allow_blank: true,
            format: { with: /\A[0-9a-zA-Z]{18}\Z/,
                      message: ' must be the 18-character Salesforce ID' },
            unless: :free?
  validates_presence_of :get_in_touch_url, if: Proc.new{|product| product.product_type == 'get_in_touch' }
  validates_presence_of :inkling_id, if: Proc.new{|product| product.product_type == 'inkling_connect' }

  validates_presence_of :available_on, if: Proc.new{|product| product.for_sale? }

  belongs_to :curriculum, class_name: '::Curriculum'
  belongs_to :grade, class_name: 'Spree::Grade'
  belongs_to :grade_unit, class_name: 'Spree::GradeUnit'

  has_many :materials
  has_many :material_import_jobs
  has_many :download_products
  has_many :download_pages, through: :download_products
  has_many :library_leafs, ->{ order(:position) }
  has_many :library_items, through: :library_leafs

  after_create :init_grades_materials

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
      'single download (legacy)',
      'video',
      'multiple download',
      'bundle',
      'group',
      'partner',
      'inkling',
      'inkling_connect',
      'get_in_touch',
      'library',
      'other',
      'flipbook'
    ]
  end

  def can_be_delete_as_free?
    free? && free_deletable?
  end

  def free?
    price == 0
  end

  def local_only?
    free? && id_in_salesforce.blank?
  end

  def digital_delivery?
    shipping_category.name == 'Digital Delivery'
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
      self.taxons << taxon if taxon && !self.taxons.where(id: taxon.id).exists?
    end
  end

  ### search indexes
  unless Spree::Product.respond_to?(:searchkick_options)
    searchkick callbacks: :async
  end

  def fulfillmentable?
     fulfillment_date.nil? || (fulfillment_date < Time.now)
  end

  def expired?
    !!(expiration_date && expiration_date < Time.now)
  end

  def should_index?
    individual_sale? && for_sale?
  end

  def search_data
    user_ids = for_sale? ?  [-1] : active_license_user_ids
    {
      name: name,
      description: description,
      bundle_names: parts.map(&:name).join(' '),
      bundle_descriptions: parts.map(&:description).join(' '),
      user_ids: user_ids
    }
  end

  def parent_bundle
    Spree::Part.where(product_id: self.id).map(&:bundle).first
  end

  def active_license_user_ids
    Spree::LicensedProduct.available.where(product_id: self.id).pluck(:user_id)
  end

  def parsed_access_url
    uri = URI.parse(access_url)
    uri.query = [uri.query, "opened_product_id=#{id}"].compact.join('&')
    uri.to_s
  end

  def group_parent_access_url
    group_parent_products.pluck(:access_url).reject(&:blank?).first
  end

  def group_parent_products
    group_product_ids = Spree::GroupItem.where(product_id: self.id).pluck(:group_id)
    Spree::Product.where(id: group_product_ids)
  end

  def max_quantity_to_purchase
    free? ? MAX_FREE_PRODUCT_QUANTITY : MAX_PAID_PRODUCT_QUANTITY
  end

  def has_license_text?
    license_text.present? || (parent_bundle && parent_bundle.license_text.present?)
  end

  def license_text_for_terms
    license_text.present? ? license_text : (parent_bundle && parent_bundle.license_text)
  end

  def update_meta_text_from_group_items
    update(meta_text: self.group_items.pluck(:name).join(', '))
  end

  def update_meta_text
    group_parent_products.each do |p|
      p.update_meta_text_from_group_items
    end
  end

  def duplicate_extra(product)
    self.sf_id_product = nil
    self.sf_id_pricebook = nil
    self.price = 0
    self.master.sku = ''
    self.inkling_code = product.inkling_code.dup if product.inkling_code
    duplicate_library_leafs(product) if product.library_leafs.exists?
    duplicate_parts(product) if product.product_type == 'bundle'
  end

  def duplicate_library_leafs(product)
    self.library_leafs = product.library_leafs.map do |library_leaf|
      library_leaf.dup.tap do |new_leaf|
        new_leaf.created_at = nil
        new_leaf.updated_at = nil
        new_leaf.library_items = library_leaf.library_items.map { |library_item| duplicate_library_item(library_item) }
      end
    end
  end

  def duplicate_library_item(library_item)
    new_library_item = library_item.dup
    new_library_item.created_at = nil
    new_library_item.updated_at = nil
    new_library_item.assign_attributes(
      :cover => library_item.cover.clone,
      :attachment => library_item.attachment.clone
    )
    new_library_item
  end

  def duplicate_parts(product)
    self.raw_parts = product.raw_parts.map { |part| part.dup }
  end

  def is_in_store?
    if group_parent_products.count > 0
      group_parent_products.each do |parent_product|
        return true if parent_product.single_in_store?
      end
    end

    return single_in_store?
  end

  def single_in_store?
    return self.show_in_storefront &&
      self.available_on.present? && self.available_on <= Time.now &&
      !self.expired? &&
      self.deleted_at.nil?
  end

  def admin_display_name
    self.internal_name.present? ? self.internal_name : self.name
  end

  def self.ransackable_attributes(*)
    %w[id
       name
       updated_at
       created_at
       description
       slug
       discontinue_on
       product_type]
  end
end
