Spree::Order.class_eval do

  def create_licensed_products!
    self.line_items.each do |line_item|
      product = line_item.variant.product
      next if product.license_length.blank?
      Spree::LicensedProduct.create!(
        order: self,
        user: self.user,
        product: product,
        quantity: line_item.quantity,
        expire_at: product.license_length.days.since(self.updated_at)
      )
    end
  end

  def promote_user_to_school_admin!
    if self.line_items.where("quantity > 1").count > 0
      self.user.assign_school_admin_role
    end
  end

  def log_purchase_activity!
    self.products.each do |product|
      self.user.log_acitivity(
        item: product,
        title: product.name,
        action: 'buy'
      )
    end
  end

  def has_license_products?
    products.first && products.first.license_text.present?
  end

  def has_digital_delivery?
    self.products.any? do |product|
      product.shipping_category.name == 'Digital Delivery' && product.digitals.present?
    end
  end

  def valid_terms_and_conditions?
    if has_license_products? && terms_and_conditions != true
      self.errors[:terms_and_conditions] << Spree.t('terms_and_conditions.must_be_accepted')
      self.errors[:terms_and_conditions].empty? ? true : false
    end
  end

  remove_checkout_step :delivery
  insert_checkout_step :delivery, after: :address, if: -> (order) { order.has_digital_delivery? }

  remove_checkout_step :terms_and_conditions
  insert_checkout_step :terms_and_conditions, :before => :delivery, if: -> (order) { order.has_license_products?  }

end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
Spree::Order.state_machine.after_transition :to => :complete, :do => :promote_user_to_school_admin!
Spree::Order.state_machine.after_transition :to => :complete, :do => :log_purchase_activity!

Spree::Order.state_machine.before_transition :to => :delivery, :do => :valid_terms_and_conditions?
