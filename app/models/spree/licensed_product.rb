class Spree::LicensedProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :user, class_name: 'Spree::User'
  belongs_to :product_distribution, class_name: 'Spree::ProductDistribution'

  include SalesforceAccess

  def self.sobject_name
    'Asset'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(fulfillment_at: sfo.InstallDate,
                    expire_at: sfo.UsageEndDate,
                    quantity: sfo.Quantity)
    sfo_data
  end

  def line_item
    order && order.line_items.find { |li| li.product.id == product.id }
  end

  def account_id_in_salesforce
    (order.try(:user) || user).try(:school_district).try(:id_in_salesforce)
  end

  def attributes_for_salesforce
    { 'Product2Id' => product.try(:sf_id_product),
      'ContactId' => user.try(:id_in_salesforce),
      'AccountId' => account_id_in_salesforce,
      'Name' => product.try(:name),
      'SerialNumber' => id,
      'InstallDate' => self.class.date_to_salesforce(fulfillment_at),
      'UsageEndDate' => self.class.date_to_salesforce(expire_at),
      'Quantity' => quantity,
      'Status' => expire_at.blank? ? 'Lifetime' : nil,
      'Order__c' => order.try(:id_in_salesforce),
      'Order_Product__c' => line_item.try(:id_in_salesforce) }
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &_block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end

  scope :available, -> {
    where("spree_licensed_products.expire_at is null or spree_licensed_products.expire_at > ?", Time.now).
    where("spree_licensed_products.quantity > 0").
    where("spree_licensed_products.fulfillment_at < ?", Time.now)
  }
  scope :expire_in_days, ->(days) { where("date(expire_at) = ?", days.days.since.to_date) }
  scope :distributable, ->{ where(can_be_distributed: true) }
  scope :undistributable, ->{ where(can_be_distributed: false) }
  scope :fulfillmentable, -> { where("spree_licensed_products.fulfillment_at < ?", Time.now) }

  validates_presence_of :product
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_numericality_of :quantity

  before_create :set_licenses_date_range, :set_user

  after_create :send_notification, :assign_user_admin_role

  def distribute_license(user_or_email, quantity=1)
    user_attrs = user_or_email.is_a?(Spree::User) ? { to_user: user_or_email } : { email: user_or_email }
    distribution_attrs = {
      licensed_product: self,
      from_user:        self.user,
      product:          self.product,
      expire_at:        self.expire_at,
    }.merge(user_attrs)
    distribution = Spree::ProductDistribution.find_or_initialize_by(distribution_attrs)
    if distribution.new_record?
      distribution.quantity = quantity
      distribution.save
    else
      distribution.increase_quantity!(quantity)
    end
    if distribution.quantity > 1
      distribution.distribute_to_self
    end
    distribution
  end

  def distribute_one_license_to_self
    update(can_be_distributed: true)
    distribute_license(self.user)
  end

  def increase_quantity!(_quantity)
    update(quantity: self.quantity + _quantity)
  end

  def decrease_quantity!(_quantity)
    update(quantity: self.quantity - _quantity)
  end

  def self.assign_license_to(user)
    Spree::LicensedProduct.where(email: user.email).find_each do |licensed_product|
      licensed_product.update(user: user)
      licensed_product.product_distribution.update(to_user: user) if licensed_product.product_distribution
    end
  end

  private

  def set_licenses_date_range
    self.fulfillment_at ||= (self.product.fulfillment_date || Time.now)
    set_expire_at
  end

  def set_expire_at
    if self.product.expiration_date.present?
      self.expire_at = self.product.expiration_date
    end
    if self.product.license_length.present?
      self.expire_at ||= product.license_length.days.since(self.fulfillment_at)
    end
  end

  def set_user
    if self.user.blank? && self.email.present?
      self.user_id = Spree::User.find_by(email: self.email).try(:id)
    end
  end

  def send_notification
    LicenseMailer.notify(self).deliver_later
  end

  def assign_user_admin_role
    if self.quantity > 1 && self.user
      self.user.assign_school_admin_role
    end
  end
end
