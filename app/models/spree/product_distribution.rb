class Spree::ProductDistribution < ActiveRecord::Base
  belongs_to :licensed_product, class_name: 'Spree::LicensedProduct'
  belongs_to :from_user, class_name: 'Spree::User'
  belongs_to :to_user, class_name: 'Spree::User'
  belongs_to :product, class_name: 'Spree::Product'

  has_one :distributed_licensed_product, class_name: 'Spree::LicensedProduct', dependent: :destroy

  validates_presence_of :product, :licensed_product

  attr_accessor :can_be_distributed

  scope :users, -> {
    joins(:product).
    distinct.
    select(:to_user_id).
    where('spree_products.expiration_date > ? or '\
          'spree_products.expiration_date is null', Time.now).
    where('spree_product_distributions.quantity > 0 and '\
          '(spree_product_distributions.expire_at is null or '\
          'spree_product_distributions.expire_at > ?)', Time.now)
  }

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

  def self.assign_distributions(user)
    Spree::ProductDistribution.where('lower(from_email) = ?', user.email.downcase).each { |d| d.update(from_user_id: user.id) }
    Spree::ProductDistribution.where('lower(email) = ?', user.email.downcase).each { |d| d.update(to_user_id: user.id) }
  end

  def revoke
    self.licensed_product.increase_quantity!(self.quantity)
    self.distributed_licensed_product.update(quantity: 0)
    self.update(quantity: 0)
  end
end
