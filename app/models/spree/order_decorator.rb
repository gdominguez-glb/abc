Spree::Order.class_eval do

  def create_licensed_products!
    self.products.where.not(license_length: nil).each do |product|
      Spree::LicensedProduct.create!(
        order: self,
        user: self.user,
        product: product,
        expire_at: product.license_length.days.since(self.updated_at)
      )
    end
  end

end

Spree::Order.state_machine.after_transition :to => :complete, :do => :create_licensed_products!
