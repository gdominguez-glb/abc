class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct'

  validates_presence_of :from_user, :product

  after_create :distribute_license

  def revoke
    self.class.transaction do
      self.licensed_product.reload && self.licensed_product.update(quantity: self.licensed_product.quantity + self.quantity) if self.licensed_product
      self.distributed_licensed_product.destroy if self.distributed_licensed_product
      self.destroy
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
