Spree::Product.class_eval do

  unless Spree::Product.respond_to?(:searchkick_options)
    searchkick
  end

  validates :license_length, numericality: { only_integer: true }, allow_blank: true
  validates :redirect_url, format: { with: URI.regexp }, allow_blank: true

  belongs_to :curriculum, class_name: 'Spree::Curriculum'
  belongs_to :grade, class_name: 'Spree::Grade'
  belongs_to :grade_unit, class_name: 'Spree::GradeUnit'

  has_many :favorite_products, class_name: 'Spree::FavoriteProduct', dependent: :destroy
  has_many :materials

  attr_accessor :new_image, :new_digital

  after_create :assign_image_to_master, :assign_digital_to_master

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
    digitals.where.not(wistia_hashed_id: nil).first
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
end
