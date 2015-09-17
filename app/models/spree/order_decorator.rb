Spree::Order.class_eval do

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

  def skip_delivery?
    self.products.all? { |product| digital_product?(product) }
  end

  def free_digital_order?
    self.products.all? do |product|
      digital_product?(product) && product.free?
    end
  end

  def digital_product?(product)
    product.shipping_category.name == 'Digital Delivery' && product.digital?
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
    go_to_state :delivery, if: -> (order) { !order.skip_delivery? }
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end
end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
Spree::Order.state_machine.after_transition :to => :complete, :do => :log_purchase_activity!

Spree::Order.state_machine.before_transition :to => :delivery, :do => :valid_terms_and_conditions?
