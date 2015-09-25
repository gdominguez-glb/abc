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

  def attributes_for_salesforce
    # TODO: Support Purchase_Type__c => Single/Group instead of hardcoding to Group
    # TODO: Support Payment_Type__c => Credit Card/PO instead of hardcoding to Credit Card
    # TODO: Support Web_Order_Complete__c => true when the order is complete (in SF)
    # TODO: Support Order_Status__c => PO Received/Full Payment Received instead of hardcoding to nil
    # TODO: Support Status => Activated only the order is complete (in SF)
    # TODO: Fix BillToContactId and ShipToContactId
    { 'Contact__c' => user.try(:id_in_salesforce),
      'Vendor_Order_Num__c' => number,
      'AccountId' => user.try(:school_district).try(:id_in_salesforce),
      'Type' => 'Online',
      'Purchase_Type__c' => 'Group',
      'Payment_Type__c' => 'Credit Card',
      'Web_Order_Complete__c' => false,
      'Order_Status__c' => nil,
      'EffectiveDate' => self.class.date_to_salesforce(created_at.utc),
      'Status' => 'Draft',
      'BillToContactId' => user.try(:id_in_salesforce),
      'ShipToContactId' => user.try(:id_in_salesforce) }
  end

  def should_create_salesforce?
    return false if state != 'complete'
    super
  end

  def create_order_in_salesforce(_transition)
    create_in_salesforce
  end

  # Do not create from salesforce, only try to find a match
  def self.find_or_create_by_salesforce_object(sfo, &_block)
    # TODO: Create from Salesforce for Web 2.0 orders made by Salesforce CSRs
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

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
Spree::Order.state_machine.after_transition :to => :complete, :do => :log_purchase_activity!
Spree::Order.state_machine.after_transition :to => :complete, :do => :create_order_in_salesforce
Spree::Order.state_machine.before_transition :to => :delivery, :do => :valid_terms_and_conditions?
