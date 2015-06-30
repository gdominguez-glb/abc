Spree::User.class_eval do

  include RailsSettings::Extend
  include ActivityLogger

  def self.defaults_email_notifications
    {
      professional_development: true,
      special_offers_and_products: true,
      revision_updates: true,
      phone_communication: true,
      email_communication: true
    }
  end

  def email_notifications
    settings[:email_notifications] || self.class.defaults_email_notifications
  end

  validates_presence_of :first_name, :last_name, :school_district

  # add any other characters you'd like to disallow inside the [ brackets ]
  # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  belongs_to :school_district

  has_many :completed_orders, ->{ where.not(completed_at: nil) }, class_name: 'Spree::Order'
  has_many :favorite_products, class_name: 'Spree::FavoriteProduct'
  has_many :licensed_products, -> { available }, class_name: 'Spree::LicensedProduct'
  has_many :products, through: :licensed_products, class_name: 'Spree::Product'
  has_many :product_distributions, foreign_key: :from_user_id, class_name: 'Spree::ProductDistribution'
  has_many :to_users, through: :product_distributions, class_name: 'Spree::User'

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  before_create :assign_user_role

  after_create :assign_licenses

  def assign_user_role
    if spree_roles.empty?
      spree_roles << Spree::Role.user
    end
  end

  def assign_school_admin_role
    if !has_school_admin_role?
      spree_roles << Spree::Role.school_admin
    end
  end

  def has_school_admin_role?
    spree_roles.where(id: Spree::Role.school_admin.id).count > 0
  end

  def has_admin_role?
    spree_roles.where(id: Spree::Role.admin.id).count > 0
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def favorited_product?(product)
    !!favorite_products.where(product_id: product.id).first
  end

  if !defined?(TITLES)
    TITLES = ['Educator', 'Administrator', 'Purchaser', 'Parent']
  end

  if !defined?(SUBJECTS)
    SUBJECTS = ['Math', 'English & Language Arts', 'History', 'Other']
  end

  def assign_licenses
    Spree::LicensedProduct.assign_license_to(self)
  end
end
