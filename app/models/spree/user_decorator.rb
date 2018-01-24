require 'mailchimp'

Spree::User.class_eval do
  include ActivityLogger
  include RailsSettings::Extend
  include RobotConfirmable
  include SalesforceAccess, SalesforceAddress
  include UserProductable, UserRolable

  scope :with_curriculum, ->(curriculum) { where("interested_subjects like '%?%'", curriculum.id) }

  serialize :interested_subjects, Array

  validates_format_of :password, with: /\A\S*\z/, message: "can't include spaces", if: :password_required?
  validates :school_district, presence: true, if: :school_district_required?
  validates :title, presence: true, on: :create
  validates :zip_code, presence: true, on: :create, if: :is_in_usa?
  validates :interested_subjects, presence: true, on: :create
  before_create :set_city_and_state, if: :school_district_required?

  belongs_to :delegate_for_user, class_name: 'Spree::User', foreign_key: :delegate_user_id

  has_many :custom_field_values
  accepts_nested_attributes_for :custom_field_values

  has_many :subscriptions, dependent: :destroy

  def subscribe!(blog)
    subscriptions.find_or_create_by(blog_id: blog.id)
  end

  def unsubscribe!(blog)
    subscriptions.where(blog_id: blog.id).destroy_all
  end

  def subscribe?(blog)
    subscriptions.where(blog_id: blog.id).exists?
  end

  def init_custom_fields
    CustomField.for_user(self).each do |custom_field|
      custom_field_value = CustomFieldValue.find_by(custom_field_id: custom_field.id, user_id: self.id)
      self.custom_field_values.build(custom_field_id: custom_field.id) if custom_field_value.blank?
    end
  end

  def filled_custom_fields?
    init_custom_fields
    self.custom_field_values.map(&:persisted?).all? && self.custom_field_values.map(&:value).all?{|c| c.present?}
  end

  def school_district_required?
    ['Teacher', 'Administrator', 'Administrative Assistant'].include?(self.title)
  end

  def state_name
    school_district.try(:state).try(:name) ||
      ship_address.try(:state).try(:name) ||
      bill_address.try(:state).try(:name)
  end

  def self.sobject_name
    'Contact'
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
    sfo_data
  end

  def attributes_for_salesforce
    attrs = { 'FirstName' => first_name.try(:capitalize),
              'LastName' => last_name.try(:capitalize),
              'AccountId' => school_district.try(:id_in_salesforce),
              'Contact_Type__c' => title,
              'Web_Front_End_Email__c' => email,
              'Web_Front_End_ID__c' => id,
              'Email' => email,
              'DoNotCall' => !allow_communication,
              'MailingPostalCode' => zip_code,
              'Contact_Referral__c' => referral,
              'Curriculum_of_Interest__c' => interested_curriculums.join(';') }


    # attrs.merge!({'BillingCity' => self.city}) if self.city.present?
    # attrs.merge!({'BillingState' => self.state}) if self.state.present?
    attrs.merge!({'Phone' => self.phone}) if self.phone.present?
    attrs.merge!(sf_address(ship_address, 'Mailing')) if ship_address.present?
    attrs.merge!(sf_address(bill_address, 'Other')) if bill_address.present?
    attrs.merge!(custom_field_values_for_salesforce)
    attrs
  end

  def new_attributes_for_salesforce
    school_district.try(:salesforce_reference).try(:reload)
    super
  end

  def custom_field_values_for_salesforce
    Hash[self.custom_field_values.displayable.map{|cfv|
      [cfv.custom_field.salesforce_field_name, cfv.value]
    }]
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

  # Performs additional tasks after creating a record in Salesforce.  This will
  # be called from within ActiveJob
  # Params:
  # +_duplicate+:: indicates if the "new" record matched an existing one
  def after_create_salesforce(duplicate = false)
    super(duplicate)
    licensed_products.each do |license|
      # Update is used instead of create because the licenses should have
      # already been created in Salesforce at the time the license was created.
      # They need to be updated to set the Contact (in Salesforce).
      # Skip the update if the create has not been run yet (e.g. "local_only").
      next if license.id_in_salesforce.blank?
      license.update_salesforce(nil, true)
    end
  end

  def grade_option
    settings[:grade_option]
  end

  # add any other characters you'd like to disallow inside the [ brackets ]
  # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  validates :first_name, :last_name, presence: true, format: {
    with: /\A[^0-9`!@#\$%\^&*+_=]+\z/, allow_blank: true
  }

  belongs_to :school_district
  has_many :materials, -> { uniq }, through: :products, class_name: 'Spree::Material'
  has_many :to_users, -> { uniq }, through: :product_distributions, class_name: 'Spree::User'
  has_many :notifications
  has_many :activities
  has_many :download_jobs
  has_many :bookmarks

  attr_accessor :school_id, :district_id, :ip_location, :hubspot_cookie, :remote_ip

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  after_commit :assign_user_role, on: :create
  after_commit :assign_to_exist_assets, on: :create
  after_commit :perform_hubspot, on: :create

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  if !defined?(USER_TITLES)
    USER_TITLES = [
      'Teacher',
      'Parent',
      'School/District Administration',
      'Curriculum Administration',
      'Homeschooler'
    ].freeze

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

    if licensed_products.distributable.exists?
      assign_school_admin_role
    end

    reload
  end

  def logins_in_last_days(days)
    activities.login.in_last_days(days).count
  end

  def last_active_date
    activities.recent.first.try(:created_at) || self.created_at
  end

  def twitter_list_code
    TWITTER_LISTS[ interested_curriculums.sort.join('_') ] || TWITTER_LISTS['English_History_Math']
  end

  after_commit :subscribe_list, on: [:create, :update]

  def subscribe_list
    if self.allow_communication?
      Mailchimp.delay.subscribe_for_user(self.id)
    else
      Mailchimp.delay.unsubscribe_user(self.id)
    end
  end

  def interested_curriculums
    Curriculum.where(id: self.interested_subjects).map(&:name)
  end

  def interested_shops
    CurriculumShop.joins(:page).joins("join curriculums on curriculums.id = pages.curriculum_id").where("curriculums.name in (?)", self.interested_curriculums).uniq
  end

  def recommendations_ids_to_exclude
    @recommendations_to_exclude ||= ids_to_exclude(Recommendation)
  end

  def whats_news_ids_to_exclude
    @whats_news_to_exclude ||= ids_to_exclude(WhatsNew)
  end

  def ids_to_exclude(model)
    return [] if accessible_products.blank?
    table_name = model.name.underscore.pluralize
    model.joins("join products_#{table_name} on products_#{table_name}.#{table_name.singularize}_id = #{table_name}.id").where("products_#{table_name}.product_id in (?)", accessible_products.map(&:id)).pluck(:id).uniq
  end

  private
  def is_in_usa?
    self.ip_location == 'US'
  end

  def set_city_and_state
    self.state = self.try(:school_district).try(:state).try(:name)
  end

  def perform_hubspot
    HubspotWorker.perform_async(ENV["hubspot_signup_guid"], {
      firstname: self.first_name,
      lastname: self.last_name,
      email: self.email,
      zip: self.zip_code,
      subject_curriculum_role: hubspot_curriculum_interests,
      role: self.title,
      country: self.try(:school_district).try(:country).try(:name),
      state: self.try(:school_district).try(:state).try(:name),
      city: self.try(:school_district).try(:city),
      company: self.try(:school_district).try(:name),
      hs_context: {ipAddress: self.remote_ip, hutk: self.hubspot_cookie}.to_json
    })
  end

  def hubspot_curriculum_interests
    self.interested_curriculums.map { |c|
      if c == 'Math'
        'Math'
      elsif c == 'English'
        'English/Humanities'
      elsif c == 'History'
        'Other'
      elsif c == 'Science'
        'Sciences'
      else
        'Other'
      end
    }
  end
end
