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

  remove_checkout_step :terms_and_conditions
  insert_checkout_step :terms_and_conditions, :before => :delivery, if: -> (order) {
    order.products.first &&
      order.products.first.license_text.present?
  }

  remove_checkout_step :delivery
  insert_checkout_step :delivery, after: :address, if: -> (order) {
    order.products.any? do |product|
      product.shipping_category.name == 'Digital Delivery' &&
        product.digitals.present?
    end
  }

end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
Spree::Order.state_machine.after_transition :to => :complete, :do => :promote_user_to_school_admin!
