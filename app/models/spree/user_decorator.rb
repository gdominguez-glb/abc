require 'mailchimp'

Spree::User.class_eval do
  include RailsSettings::Extend
  include ActivityLogger
  include SalesforceAccess

  scope :with_curriculum, ->(curriculum) { where("interested_subjects like '%?%'", curriculum.id) }

  serialize :interested_subjects, Array

  validates_format_of :password, with: /\A\S*\z/, message: "can't include spaces", if: :password_required?
  validates :school_district, presence: true

  belongs_to :delegate_for_user, class_name: 'Spree::User', foreign_key: :delegate_user_id

  def self.sobject_name
    'Contact'
  end

  def self.address_attributes(sfo, type = 'Mailing')
    return nil unless %w(Mailing Other).member?(type)
    country = Spree::Country.find_by(iso3: sfo.send("#{type}Country"))
    state_criteria = { abbr: sfo.send("#{type}State") }
    state_criteria.merge!(country: country) if country.present?
    state = Spree::State.find_by(state_criteria)
    country = state.country if country.blank? && state.present?
    phone = sfo.Phone
    phone = '000-000-0000' if phone.blank?

    attrs = {
      first_name: sfo.FirstName,
      last_name: sfo.LastName,
      phone: phone,
      address1: sfo.send("#{type}Street"),
      city: sfo.send("#{type}City"),
      state: state,
      zipcode: sfo.send("#{type}PostalCode"),
      country: country
    }
    return {} if attrs[:first_name].blank? ||
                 attrs[:last_name].blank? ||
                 attrs[:address1].blank? ||
                 attrs[:city].blank? ||
                 attrs[:country].blank? ||
                 attrs[:zipcode].blank? ||
                 attrs[:phone].blank?
    attrs
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(first_name: sfo.FirstName,
                    last_name: sfo.LastName,
                    email: sfo.Email,
                    phone: sfo.Phone,
                    title: sfo.Contact_Type__c,
                    allow_communication: !sfo.DoNotCall)
    ship_addr = address_attributes(sfo, 'Mailing')
    sfo_data.merge!(ship_address_attributes: ship_addr) if ship_addr.present?
    bill_addr = address_attributes(sfo, 'Other')
    sfo_data.merge!(bill_address_attributes: bill_addr) if bill_addr.present?

    school_district_record = SchoolDistrict.joins(:salesforce_reference)
      .where('salesforce_references.id_in_salesforce' => sfo.AccountId).first
    if school_district_record
      sfo_data.merge! school_district_id: school_district_record.id
    end
    # TODO: handle the case where the district is not found
    # TODO: Also update address information
    sfo_data
  end

  def sf_address(addr, prefix = 'Mailing')
    return nil if addr.blank? || !(%w(Mailing Other).member?(prefix))
    # TODO: use this, when supported: [addr.address1, addr.address2].join("\n")
    { "#{prefix}Street" => addr.address1,
      "#{prefix}City" => addr.city,
      "#{prefix}State" => addr.state.try(:abbr),
      "#{prefix}PostalCode" => addr.zipcode,
      "#{prefix}Country" => addr.country.try(:iso3)
    }
  end

  def attributes_for_salesforce
    attrs = { 'FirstName' => first_name,
              'LastName' => last_name,
              'AccountId' => school_district.try(:id_in_salesforce),
              'Contact_Type__c' => title,
              'Web_Front_End_Email__c' => email,
              'Web_Front_End_ID__c' => id,
              'Email' => email,
              'Phone' => phone,
              'DoNotCall' => !allow_communication }
    attrs.merge!(sf_address(ship_address, 'Mailing')) if ship_address.present?
    attrs.merge!(sf_address(bill_address, 'Other')) if bill_address.present?
    attrs
  end

  def new_attributes_for_salesforce
    school_district.try(:salesforce_reference).try(:reload)
    super
  end

  # Provides a means to bypass creation in Salesforce.  For example, this is
  # used to prevent the creation in Salesforce of a record created locally from
  # Salesforce
  def should_create_salesforce?
    return false if !super || school_district.try(:id_in_salesforce).blank?
    true
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
  has_many :licensed_products, -> { available }, class_name: 'Spree::LicensedProduct'
  has_many :products, -> { unexpire.order('spree_licensed_products.id desc') }, through: :licensed_products, class_name: 'Spree::Product'
  has_many :materials, -> { uniq }, through: :products, class_name: 'Spree::Material'
  has_many :product_distributions, foreign_key: :from_user_id, class_name: 'Spree::ProductDistribution'
  has_many :to_users, -> { uniq }, through: :product_distributions, class_name: 'Spree::User'
  has_many :notifications
  has_many :activities
  has_many :download_jobs
  has_many :product_tracks
  has_many :bookmarks
  has_many :product_agreements, class_name: 'Spree::ProductAgreement'

  attr_accessor :school_id, :district_id

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  after_commit :assign_user_role, :assign_to_exist_assets, on: :create

  def part_products
    part_product_ids = licensed_products.
      joins("join spree_parts on spree_parts.bundle_id = spree_licensed_products.product_id").
      joins("join spree_products on spree_parts.product_id = spree_products.id").
      select("distinct(spree_products.id)").map(&:id)
    Spree::Product.where(id: part_product_ids)
  end

  def licensed_products_from(school_district_admin)
    licensed_products.joins(:product).joins(:product_distribution).where({spree_product_distributions: { from_user_id: school_district_admin.id }}).uniq
  end

  def assign_user_role
    spree_roles << Spree::Role.user
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

  if !defined?(USER_TITLES)
    USER_TITLES = ['Teacher', 'Administrator', 'Parent', 'Administrative Assistant', 'Homeschooler'].freeze

    USER_TITLES.each do |title|
      scope "with_#{title.downcase}_title", -> { where(title: title) }
    end
  end

  if !defined?(SUBJECTS)
    SUBJECTS = ['Math', 'English & Language Arts', 'History', 'Other']
  end

  def assign_to_exist_assets
    assign_licenses
    assign_distributions
    Legacy::Migrater.new(self).execute

    if licensed_products.where('quantity > 1').exists?
      assign_school_admin_role
    end

    reload
  end

  def assign_licenses
    Spree::LicensedProduct.assign_license_to(self)
  end

  def assign_distributions
    Spree::ProductDistribution.assign_distributions(self)
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

  def managed_products_options
    licensed_products.fulfillmentable.distributable.includes(:product).group_by { |lp| "#{lp.product.name} expiring #{lp.expire_at.strftime("%B %Y") rescue nil}" }.map do |key, licenses|
      [key, licenses.map(&:id).sort.join(',')]
    end
  end

  def purchased_licenses_count(licenses_ids)
    distributed_licenses_count(licenses_ids) + remaining_licenses_count(licenses_ids)
  end

  def distributed_licenses_count(licenses_ids)
    product_distributions.where(licensed_product_id: licenses_ids).sum(:quantity)
  end

  def remaining_licenses_count(licenses_ids)
    licensed_products.where(id: licenses_ids).sum(:quantity)
  end

  def logins_in_last_days(days)
    activities.login.in_last_days(days).count
  end

  def last_active_date
    activities.recent.first.try(:created_at) || self.created_at
  end

  def has_active_license_on?(product)
    licensed_products.where(product_id: product.id).exists?
  end

  def interested_curriculums_names
    Curriculum.where(id: self.interested_subjects).order('name asc').pluck(:name)
  end

  def twitter_list_code
    TWITTER_LISTS[interested_curriculums_names.join('_')]
  end

  def has_more_than_3_products?
    sql = <<-SQL
      select 1 from
        (
        select sum(quantity) as quantity_count from
          (
            ( select product_id, quantity from spree_licensed_products where user_id = #{self.id} )
            UNION
            ( select product_id, quantity from spree_product_distributions where from_user_id = #{self.id})
          ) a group by a.product_id
        ) b where b.quantity_count > 3
    SQL
    result = ActiveRecord::Base.connection.execute(sql)
    result.count > 0
  end

  def agree_term_of_product?(product)
    self.product_agreements.where(product: product).exists?
  end

  before_save :subscribe_list

  def subscribe_list
    if self.allow_communication_changed?
      if self.allow_communication?
        Mailchimp.delay.subscribe_for_user(self.id)
      else
        Mailchimp.delay.unsubscribe_user(self.id)
      end
    end
  end

  def interested_curriculums
    Curriculum.where(id: self.interested_subjects).map(&:name)
  end

  def interested_shops
    CurriculumShop.joins(:page).joins("join curriculums on curriculums.id = pages.curriculum_id").where("curriculums.name in (?)", self.interested_curriculums).uniq
  end
end
