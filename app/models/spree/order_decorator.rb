Spree::Order.class_eval do
  has_many :licensed_products, class_name: 'Spree::LicensedProduct'

  belongs_to :school_district
  belongs_to :admin_user, class_name: 'Spree::User'

  enum source: { web: 0, fulfillment: 1, cc_process: 2 }

  include SalesforceAccess
  include SalesforceAddress

  attr_accessor :distribute_option

  validates_format_of :license_admin_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, if: ->(o) { o.distribute_option == 'someone' }
  validate :validate_trial_products

  before_save :check_terms_and_conditions

  def manual_process_order!(payment)
    self.payments << payment
    self.save
    count = 0
    while count < 6
      self.next if self.state != 'complete'
      count += 1
    end
  end

  # overwrite to bypass validation for cc process
  def ensure_line_items_present
    if line_items.empty? && !self.cc_process?
      errors.add(:base, Spree.t(:there_are_no_items_for_this_order)) and return false
    end
  end

  def check_terms_and_conditions
    if self.user && self.terms_and_conditions_changed? && self.terms_and_conditions?
      self.products.each do |product|
        self.user.product_agreements.find_or_create_by(product: product)
      end
    end
  end

  def self.sobject_name
    'Order'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    user = sfo.Contact__c && Spree::User.joins(:salesforce_reference).where(
      'salesforce_references.id_in_salesforce' => sfo.Contact__c).first
    sfo_data.merge!(number: sfo.Vendor_Order_Num__c,
                    user_id: user.try(:id))
    ship_addr = address_attributes(sfo, 'Shipping')
    sfo_data.merge!(ship_address_attributes: ship_addr) if ship_addr.present?
    bill_addr = address_attributes(sfo, 'Billing')
    sfo_data.merge!(bill_address_attributes: bill_addr) if bill_addr.present?
    sfo_data
  end

  # Indicates whether any items ordered are for a quantity of more than one.
  # This is needed to set the Salesforce `Purchase_Type__c` to `Single` or
  # `Group`
  def multi_license?
    line_items.any? { |li| li.quantity > 1 }
  end

  def payment_type
    payments.first.try(:payment_method).try(:name)
  end

  def salesforce_complete?
    return false if line_items.blank?
    return false if id_in_salesforce.blank?
    return true if fulfillment?
    line_items.all? { |line_item| line_item.id_in_salesforce.present? }
  end

  def payment_received?
    salesforce_complete? && payment_type == 'Credit Card'
  end

  def pricebook_id
    # TODO: Need a better way to get this
    pbids = line_items.all.map { |li| li.try(:product).try(:sf_id_pricebook) }
    pbid = pbids.reject(&:blank?).first
    return pbid if pbid.present?
    Spree::Product.where(
      "sf_id_pricebook <> '' AND sf_id_pricebook IS NOT NULL"
    ).limit(1).pluck(:sf_id_pricebook).first
  end

  def attributes_for_salesforce
    salesforce_user_id = user.try(:id_in_salesforce)
    # Purchase_Type__c => Single/Group based on `multi_license?`
    # Payment_Type__c => Credit Card/Check/PO
    # Order_Status__c => PO Received/Full Payment Received
    attrs = { 'Contact__c' => user.try(:id_in_salesforce),
              'Pricebook2Id' => pricebook_id,
              'Vendor_Order_Num__c' => number,
              'AccountId' => (user.try(:school_district) || school_district).try(:id_in_salesforce),
              'Type' => 'Online',
              'Purchase_Type__c' => multi_license? ? 'Group' : 'Single',
              'Payment_Type__c' => payment_type,
              'Web_Order_Complete__c' => salesforce_complete?,
              'EffectiveDate' => self.class.date_to_salesforce(created_at.utc),
              'Status' => salesforce_complete? ? 'Activated' : 'Draft',
              'BillToContactId' => bill_address && salesforce_user_id,
              'Order_Phone__c' => bill_address.try(:phone),
              'ShipToContactId' => ship_address && salesforce_user_id }

    # TODO: Support Order_Status__c => PO Received/Full Payment Received instead
    #       of just 'Full Payment Received'
    if payment_received?
      attrs.merge('Order_Status__c' => 'Full Payment Received')
    elsif complete?
      attrs.merge('Order_Status__c' => 'License Activated')
    end

    attrs.merge!(sf_address(ship_address, 'Shipping')) if ship_address.present?
    attrs.merge!(sf_address(bill_address, 'Billing')) if bill_address.present?
    attrs
  end

  def mark_order_complete_in_salesforce
    # TODO: Handle both modified case
    sfo = cached_salesforce_object
    return false unless sfo
    attributes_to_update = changed_attributes_for_salesforce(sfo)
    return {} if attributes_to_update.blank?

    update_record_in_salesforce(attributes_to_update)
  end

  def skip_salesforce_sync?
    return true if cc_process?
    false
  end

  def should_create_salesforce?
    return false if state != 'complete'
    super
  end

  # Performs additional tasks after creating a record in Salesforce.  This will
  # be called from within ActiveJob
  # Params:
  # +_duplicate+:: indicates if the "new" record matched an existing one
  def after_create_salesforce(duplicate = false)
    super
    line_items.each do |line_item|
      # Skip this line item if it has already been created.  This can happen
      # if there is an error trying to create the order and it is retried
      next if line_item.id_in_salesforce.present? || line_item.local_only?
      line_item.create_in_salesforce(nil, false)
    end
    mark_order_complete_in_salesforce
    licensed_products.each do |license|
      # Update is used instead of create because the licenses should have
      # already been created in Salesforce at the time the license was created.
      # They need to be updated to set the Order (in Salesforce).
      # Skip the update if the create has not been run yet.
      next if license.id_in_salesforce.blank?
      license.update_salesforce(nil, true, true)
    end
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &_block)
    return nil if sfo.blank?
    matches_salesforce_object(sfo).first
  end

  def create_licensed_products!
    Spree::LicensesManager::OrderLicenser.new(self).execute
  end

  def log_purchase_activity!
    return unless self.user
    self.products.each do |product|
      self.user.log_activity(
        item: product,
        title: product.name,
        action: 'buy'
      )
    end
  end

  def has_license_products?
    self.products.any? do |product|
      product.license_text.present?
    end
  end

  def all_digitals?
    self.products.all? { |product| product.digital_delivery? }
  end

  def free_digital_order?
    self.products.all? do |product|
      product.digital_delivery? && product.free?
    end
  end

  def validate_terms_and_conditions
    if has_license_products? && terms_and_conditions != true
      self.errors[:terms_and_conditions] << Spree.t('terms_and_conditions.must_be_accepted')
      self.errors[:terms_and_conditions].empty? ? true : false
    end
  end

  def validate_trial_products
    return if self.user.blank?
    self.line_items.each do |line_item|
      if line_item.quantity > 0 && self.user.bought_free_trial_product?(line_item.variant.product)
        self.errors.add(:base, "Bought #{line_item.variant.product.name} before (Can only buy trial products once)")
      end
    end
  end

  def finalize_order
    create_in_salesforce
    create_licensed_products!
    log_purchase_activity!
  end

  def deliver_order_confirmation_email
    return if free? || fulfillment?
    # Spree::OrderMailer.confirm_email(id).deliver_later
    update_column(:confirmation_delivered, true)
  end

  def free?
    total == 0.0
  end

  def single_purchase?
    line_items.sum(:quantity) == 1
  end

  checkout_flow do
    go_to_state :address, if: -> (order) { !order.free_digital_order? }
    go_to_state :terms_and_conditions, if: -> (order) { order.has_license_products? }
    go_to_state :delivery, if: -> (order) { !order.all_digitals? }
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end
end

Spree::Order.state_machine.after_transition to: :complete, do: :finalize_order

Spree::Order.state_machine.before_transition to: :payment, do: :validate_terms_and_conditions
Spree::Order.state_machine.before_transition to: :delivery, do: :validate_terms_and_conditions
Spree::Order.state_machine.before_transition to: :confirm, do: :validate_terms_and_conditions
