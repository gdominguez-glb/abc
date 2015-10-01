Spree::Order.class_eval do
  include SalesforceAccess

  def self.sobject_name
    'Order'
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    user = sfo.Contact__c && Spree::User.joins(:salesforce_reference).where(
      'salesforce_references.id_in_salesforce' => sfo.Contact__c).first
    sfo_data.merge!(number: sfo.Vendor_Order_Num__c,
                    user_id: user.id)
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
    line_items.all? { |line_item| line_item.id_in_salesforce.present? }
  end

  def payment_received?
    salesforce_complete? && payment_type == 'Credit Card'
  end

  def pricebook_id
    # TODO: Need a better way to get this
    pbids = line_items.all.map { |li| li.try(:product).try(:sf_id_pricebook) }
    pbid = pbids.compact.first
    return pbid if pbid
    Spree::Product.where('sf_id_pricebook IS NOT NULL').pluck(:sf_id_pricebook)
  end

  def attributes_for_salesforce
    salesforce_user_id = user.try(:id_in_salesforce)
    # Purchase_Type__c => Single/Group based on `multi_license?`
    # Payment_Type__c => Credit Card/Check/PO
    # Order_Status__c => PO Received/Full Payment Received
    attrs = { 'Contact__c' => user.try(:id_in_salesforce),
              'Pricebook2Id' => pricebook_id,
              'Vendor_Order_Num__c' => number,
              'AccountId' => user.try(:school_district).try(:id_in_salesforce),
              'Type' => 'Online',
              'Purchase_Type__c' => multi_license? ? 'Group' : 'Single',
              'Payment_Type__c' => payment_type,
              'Web_Order_Complete__c' => salesforce_complete?,
              'EffectiveDate' => self.class.date_to_salesforce(created_at.utc),
              'Status' => salesforce_complete? ? 'Activated' : 'Draft',
              'BillToContactId' => bill_address && salesforce_user_id,
              'ShipToContactId' => ship_address && salesforce_user_id }

    # TODO: Support Order_Status__c => PO Received/Full Payment Received instead
    #       of just 'Full Payment Received'
    if payment_received?
      attrs.merge('Order_Status__c' => 'Full Payment Received')
    end

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

  def should_create_salesforce?
    return false if state != 'complete'
    super
  end

  def create_order_in_salesforce
    create_in_salesforce
  end

  # Performs additional tasks after creating a record in Salesforce.  This will
  # be called from within ActiveJob
  # Params:
  # +_duplicate+:: indicates if the "new" record matched an existing one
  def after_create_salesforce(duplicate = false)
    return true if duplicate
    line_items.each do |line_item|
      line_item.create_in_salesforce(nil, false)
    end
    mark_order_complete_in_salesforce
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

  def valid_terms_and_conditions?
    if has_license_products? && terms_and_conditions != true
      self.errors[:terms_and_conditions] << Spree.t('terms_and_conditions.must_be_accepted')
      self.errors[:terms_and_conditions].empty? ? true : false
    end
  end

  def finalize_order
    create_order_in_salesforce
    create_licensed_products!
    log_purchase_activity!
  end

  checkout_flow do
    go_to_state :address, if: -> (order) { !order.free_digital_order? }
    go_to_state :terms_and_conditions, if: -> (order) { order.has_license_products?  }
    go_to_state :delivery, if: -> (order) { !order.all_digitals? }
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end
end

Spree::Order.state_machine.after_transition to: :complete, do: :finalize_order
Spree::Order.state_machine.before_transition to: :delivery,
                                             do: :valid_terms_and_conditions?
