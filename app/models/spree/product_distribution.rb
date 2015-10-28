class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct', dependent: :destroy

  validates_presence_of :product, :licensed_product

  attr_accessor :can_be_distributed

  include EmailAssignment
  assign_user_from_email :to_user, :email
  assign_user_from_email :from_user, :from_email

  assign_email_from_user :email, :to_user
  assign_email_from_user :from_email, :from_user

  def decrease_quantity!(_quantity)
    self.update(quantity: (quantity - _quantity))
    self.distributed_licensed_product.decrease_quantity!(_quantity)
  end

  def increase_quantity!(_quantity)
    self.update(quantity: (quantity + _quantity))
    self.distributed_licensed_product.increase_quantity!(_quantity)
  end

  def self.from_user_to_email(from_user, email)
    Spree::ProductDistribution.joins(:product).where(from_user_id: from_user.id, email: email).uniq
  end

  def distribute_to_self
    Spree::ProductDistribution.create(
      from_user: to_user,
      from_email: from_email,
      to_user: to_user,
      email: email,
      product: product,
      licensed_product: self.distributed_licensed_product,
      quantity: 1,
      can_be_distributed: false
    )
    self.update(quantity: (quantity - 1))
  end

  def self.assign_distributions(user)
    Spree::ProductDistribution.where(from_email: user.email).update_all(from_user_id: user.id)
    Spree::ProductDistribution.where(email: user.email).update_all(to_user_id: user.id)
  end

  def revoke
    self.licensed_product.increase_quantity!(self.quantity)
    self.distributed_licensed_product.update(quantity: 0)
    self.update(quantity: 0)
  end
end
