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

end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
