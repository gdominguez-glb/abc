class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct', dependent: :destroy

  validates_presence_of :from_user, :product, :licensed_product

  after_create :distribute_license

  def revoke(_quantity)
    self.class.transaction do
      self.licensed_product.increase_quantity!(_quantity)
      if _quantity < self.quantity
        decrease_quantity!(_quantity)
      else
        self.destroy
      end
    end
  end

  def reassign_to(user_or_email, _quantity)
    return false if _quantity > self.quantity
    self.class.transaction do
      Spree::ProductDistribution.create({
        licensed_product: self.licensed_product,
        product: self.product,
        from_user: self.from_user,
        quantity: _quantity
      }.merge(user_or_email.is_a?(Spree::User) ? { to_user: user_or_email } : { email: user_or_email } ))
      if _quantity < self.quantity
        self.decrease_quantity!(_quantity)
      else
        self.destroy
      end
    end
  end

  def decrease_quantity!(_quantity)
    self.update(quantity: (quantity - _quantity))
    self.distributed_licensed_product.decrease_quantity!(_quantity)
  end

  private

  def distribute_license
    licensed_product.decrease_quantity!(self.quantity)
    Spree::LicensedProduct.create(
      user: self.to_user,
      email: self.email,
      quantity: self.quantity,
      product: self.product,
      product_distribution: self
    )
  end
end
