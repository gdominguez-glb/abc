class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct'

  validates_presence_of :from_user, :product

  after_create :distribute_license

  def revoke(_quantity)
    self.class.transaction do
      if _quantity < self.quantity
        self.licensed_product.update(quantity: self.licensed_product.quantity + _quantity)
        self.update(quantity: (self.quantity - _quantity))
        self.distributed_licensed_product.update(quantity: (self.distributed_licensed_product.quantity - _quantity))
      else
        self.licensed_product.update(quantity: self.licensed_product.quantity + self.quantity)
        self.distributed_licensed_product.destroy
        self.destroy
      end
    end
  end

  def reassign_to(user_or_email, _quantity)
    return false if _quantity > self.quantity
    self.class.transaction do
      Spree::ProductDistribution.create({
        product: self.product,
        from_user: self.from_user,
        quantity: _quantity
      }.merge(user_or_email.is_a?(Spree::User) ? { to_user: user_or_email } : { email: user_or_email } ))
      if _quantity < self.quantity
        self.update(quantity: (self.quantity - _quantity))
        self.licensed_product.update(quantity: (self.quantity - _quantity))
      else
        self.licensed_product.destroy
        self.destroy
      end
    end
  end

  private

  def distribute_license
    from_licensed_product = from_user.licensed_products.find_by(product_id: self.product.id)
    if from_licensed_product && from_licensed_product.quantity > self.quantity
      from_licensed_product.update(quantity: from_licensed_product.quantity - self.quantity)
      Spree::LicensedProduct.create(
        user: self.to_user,
        email: self.email,
        quantity: self.quantity,
        product: self.product,
        product_distribution: self
      )
    end
  end
end
