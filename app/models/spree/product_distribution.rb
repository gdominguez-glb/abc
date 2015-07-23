class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct', dependent: :destroy

  validates_presence_of :from_user, :product, :licensed_product

  after_create :distribute_license

  def decrease_quantity!(_quantity)
    self.update(quantity: (quantity - _quantity))
    self.distributed_licensed_product.decrease_quantity!(_quantity)
  end

  def increase_quantity!(_quantity)
    self.update(quantity: (quantity + _quantity))
    self.distributed_licensed_product.increase_quantity!(_quantity)
  end

  private

  def distribute_license
    licensed_product.decrease_quantity!(self.quantity)
    Spree::LicensedProduct.create(
      user: self.to_user,
      email: self.email,
      quantity: self.quantity,
      product: self.product,
      expire_at: self.expire_at,
      product_distribution: self
    )
  end
end
