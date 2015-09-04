Spree::User.class_eval do
  include RailsSettings::Extend
  include ActivityLogger
  include SalesforceAccess

  validates_format_of :password, with: /\A\S*\z/, message: "can't include spaces", if: :password_required?

  def self.sobject_name
    'Contact'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(first_name: sfo.FirstName,
                    last_name: sfo.LastName,
                    email: sfo.Email,
                    title: sfo.Contact_Type__c)
    school_district_record = SchoolDistrict.joins(:salesforce_reference)
      .where('salesforce_references.id_in_salesforce' => sfo.AccountId).first
    if school_district_record
      sfo_data.merge! school_district_id: school_district_record.id
    end
    # TODO: handle the case where the district is not found
    # TODO: Also update address information
    sfo_data
  end

  def attributes_for_salesforce
    { 'FirstName' => first_name,
      'LastName' => last_name,
      'AccountId' => school_district.try(:salesforce_reference)
                     .try(:id_in_salesforce),
      'Contact_Type__c' => title,
      'Web_Front_End_Email__c' => email,
      'Web_Front_End_ID__c' => id,
      'Email' => email }
  end

  def new_attributes_for_salesforce
    school_district.try(:salesforce_reference).try(:reload)
    super
  end

  def self.matches_salesforce_object(sfo)
    matches = super(sfo)
    return matches if matches.present?
    return none if sfo.Email.blank?
    where email: sfo.Email
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end

  def self.defaults_email_notifications
    {
      professional_development: true,
      special_offers_and_products: true,
      revision_updates: true,
      phone_communication: true,
      email_communication: true,
      receive_math: true,
      receive_english: true,
      receive_history: true
    }
  end

  def email_notifications
    settings[:email_notifications] || self.class.defaults_email_notifications
  end

  def accept_email?
    email_notifications[:email_communication] == true
  end

  def grade_option
    settings[:grade_option]
  end

  validates :school_district, presence: true, if: :require_shool_district?

  # add any other characters you'd like to disallow inside the [ brackets ]
  # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  validates :first_name, :last_name, presence: true, format: {
    with: /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_blank: true
  }

  belongs_to :school_district

  has_many :completed_orders, -> { where.not(completed_at: nil) }, class_name: 'Spree::Order'
  has_many :favorite_products, class_name: 'Spree::FavoriteProduct'
  has_many :licensed_products, -> { available }, class_name: 'Spree::LicensedProduct'
  has_many :products, through: :licensed_products, class_name: 'Spree::Product'
  has_many :materials, -> { uniq }, through: :products, class_name: 'Spree::Material'
  has_many :product_distributions, foreign_key: :from_user_id, class_name: 'Spree::ProductDistribution'
  has_many :to_users, -> { uniq }, through: :product_distributions, class_name: 'Spree::User'
  has_many :notifications
  has_many :activities
  has_many :download_jobs
  has_many :product_tracks

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  before_create :assign_user_role

  after_create :assign_licenses

  def licensed_products_from(school_district_admin)
    licensed_products.joins(:product).joins(:product_distribution).where({spree_product_distributions: { from_user_id: school_district_admin.id }}).uniq
  end

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

  if !defined?(USER_TITLES)
    USER_TITLES = ['Teacher', 'Administrator', 'Parent', 'Administrative Assistant', 'Homeschooler'].freeze

    USER_TITLES.each do |title|
      scope "with_#{title.downcase}_title", -> { where(title: title) }
    end
  end

  if !defined?(SUBJECTS)
    SUBJECTS = ['Math', 'English & Language Arts', 'History', 'Other']
  end

  def assign_licenses
    Spree::LicensedProduct.assign_license_to(self)
  end

  def require_shool_district?
    ['Teacher', 'Administrative Assistant', 'Administrator'].include?(self.title)
  end

  def managed_products
    @managed_products ||= begin
      product_ids = licensed_products.distributable.pluck(:product_id) + product_distributions.pluck(:product_id)
      Spree::Product.where(id: product_ids).order("name asc")
    end
  end

  def purchased_licenses_count(product)
    distributed_licenses_count(product) + licensed_products.distributable.where(product_id: product.id).sum(:quantity)
  end

  def distributed_licenses_count(product)
    product_distributions.where(product_id: product.id).sum(:quantity)
  end

  def remaining_licenses_count(product)
    purchased_licenses_count(product) - distributed_licenses_count(product)
  end

  def logins_in_last_days(days)
    activities.login.in_last_days(days).count
  end

  def last_active_date
    activities.recent.first.try(:created_at) || self.created_at
  end
end
