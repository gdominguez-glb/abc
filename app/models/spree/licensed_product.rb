class Spree::LicensedProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product_distribution, class_name: 'Spree::ProductDistribution'
  belongs_to :admin_user, class_name: 'Spree::User'
  belongs_to :coupon_code, class_name: 'Spree::CouponCode'

  include SalesforceAccess

  def self.sobject_name
    'Asset'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(expire_at: sfo.UsageEndDate,
                    quantity: sfo.Quantity)
    sfo_data
  end

  def local_only?
    product && product.local_only?
  end

  def should_create_salesforce?
    return false if local_only?
    super
  end

  def skip_salesforce_sync?
    return true if order_id.blank?
    false
  end

  def line_item
    order && order.line_items.find { |li| li.product.id == product.id }
  end

  def assign_to_user_id_in_salesforce
    assign_user = user || product_distribution.try(:from_user)
    return order.try(:sf_contact_id) unless assign_user

    if assign_user.id_in_salesforce.blank? && !skip_salesforce_create
      assign_user.create_in_salesforce(nil, false)
      assign_user.reload
    end

    assign_user.id_in_salesforce
  end

  def account_id_in_salesforce
    school_district = school_district_for_salesforce
    school_district.try(:id_in_salesforce)
  end

  def school_district_for_salesforce
    return order.school_district if order && order.fulfillment? && order.school_district
    school_district = school_district_from_user || order.try(:school_district)

    if should_manual_sync_school_district?(school_district)
      school_district.manual_sync_to_salesforce
    end
    school_district
  end

  def school_district_from_user
    account_user = order.try(:user) || product_distribution.try(:from_user) || user
    account_user.try(:school_district)
  end

  def should_manual_sync_school_district?(school_district)
    school_district && school_district.id_in_salesforce.blank? && !skip_salesforce_create
  end

  def attributes_for_salesforce
    { 'Product2Id' => product.try(:sf_id_product),
      'ContactId' => assign_to_user_id_in_salesforce,
      'AccountId' => account_id_in_salesforce,
      'Name' => product.try(:name),
      'SerialNumber' => id,
      'InstallDate' => self.class.date_to_salesforce(fulfillment_at),
      'UsageEndDate' => self.class.date_to_salesforce(expire_at),
      'Quantity' => quantity,
      'Status' => expire_at.blank? ? 'Lifetime' : nil,
      'Order__c' => order.try(:id_in_salesforce),
      'Deactivated__c' => quantity && quantity < 1 }
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &_block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end

  scope :available, -> {
    unexpire.
    fulfillmentable.
    where("spree_licensed_products.quantity > 0")
  }
  scope :unexpire, -> { where("spree_licensed_products.expire_at is null or spree_licensed_products.expire_at > ?", Time.now) }
  scope :expire_in_days, ->(days) { where("date(expire_at) = ?", days.days.since.to_date) }
  scope :distributable, ->{ where(can_be_distributed: true) }
  scope :undistributable, ->{ where(can_be_distributed: false) }
  scope :fulfillmentable, -> { where("spree_licensed_products.fulfillment_at < ? or spree_licensed_products.fulfillment_at is NULL", Time.now) }
  scope :quantible, -> { where("spree_licensed_products.quantity > 0") }

  validates_presence_of :product
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_numericality_of :quantity

  attr_accessor :lifetime_product

  before_create :set_licenses_date_range
  after_create :set_activity

  include EmailAssignment
  assign_user_from_email :user, :email
  assign_email_from_user :email, :user

  attr_accessor :skip_notification

  def increase_quantity!(add_quantity)
    update(quantity: quantity + add_quantity)
  end

  def decrease_quantity!(subtract_quantity)
    update(quantity: quantity - subtract_quantity)
  end

  def self.assign_license_to(user, skip_salesforce_update = false)
    Spree::LicensedProduct.where('lower(email) = ?', user.email.downcase).find_each do |licensed_product|
      licensed_product.update(user: user, skip_next_salesforce_update: skip_salesforce_update)
    end
  end

  def self.exist_product_license_not_expire?(licensed_product)
    Spree::LicensedProduct.
      where('email = ?', licensed_product.email).
      where(can_be_distributed: false, product_id: licensed_product.product_id, quantity: 1).
      where('id != ?', licensed_product.id).
      where('(expire_at IS NULL OR expire_at > ?)', Time.now).exists?
  end

  private

  def set_licenses_date_range
    set_fulfillment_at
    set_expire_at
  end

  def set_fulfillment_at
    self.fulfillment_at ||= (self.product.fulfillment_date || Time.now)
    if self.order &&
      self.order.fulfillment_at &&
      self.order.fulfillment_at > self.fulfillment_at
      self.fulfillment_at = self.order.fulfillment_at
    end
  end

  def set_expire_at
    return if self.lifetime_product && self.expire_at.blank?
    if self.product.expiration_date.present?
      self.expire_at ||= self.product.expiration_date
    end
    if self.product.license_length.present?
      self.expire_at ||= product.license_length.days.since(self.fulfillment_at)
    end
  end

  def set_activity
    user.update_log_activity_product(product) unless user.nil?
  end
end
