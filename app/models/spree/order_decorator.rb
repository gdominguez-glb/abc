Spree::Order.class_eval do

  def create_licensed_products!
    self.line_items.each do |line_item|
      product = line_item.variant.product
      products_to_license = product.parts.empty? ? [product] : product.parts
      products_to_license.each do |product|
        licensed_product = Spree::LicensedProduct.create!(
          order: self,
          user: self.user,
          product: product,
          quantity: line_item.quantity
        )
        check_distributable_licenses(licensed_product)
      end
    end
  end

  def check_distributable_licenses(licensed_product)
    return if licensed_product.quantity == 1
    licensed_product.update(can_be_distributed: true)
    licensed_product.distribute_one_license_to_self
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

  def has_digital_delivery?
    self.products.any? do |product|
      product.shipping_category.name == 'Digital Delivery' && product.digitals.present?
    end
  end

  def free_digital_order?
    self.products.all? do |product|
      product.shipping_category.name == 'Digital Delivery' && product.digitals.present? && product.free?
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
    go_to_state :delivery, if: -> (order) { order.has_digital_delivery? }
    go_to_state :payment, if: ->(order) { order.payment_required? }
    go_to_state :confirm, if: ->(order) { order.confirmation_required? }
    go_to_state :complete
    remove_transition from: :delivery, to: :confirm
  end
end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
Spree::Order.state_machine.after_transition :to => :complete, :do => :log_purchase_activity!

Spree::Order.state_machine.before_transition :to => :delivery, :do => :valid_terms_and_conditions?
