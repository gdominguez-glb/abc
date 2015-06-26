class Spree::LicensedProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :user, class_name: 'Spree::User'

  scope :available, -> { where("expire_at > ?", Time.now) }

  validates_presence_of :product
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, allow_blank: true
  validates_numericality_of :quantity, :greater_than => 0

  before_create :set_expire_at, :set_user

  def distribute_license(user_or_email, quantity=1)
    distribution_attrs = {
      licensed_product: self,
      from_user:        self.user,
      product:          self.product,
      quantity:         quantity
    }
    if user_or_email.is_a?(Spree::User)
      distribution_attrs[:to_user] = user_or_email
    else
      distribution_attrs[:email] = user_or_email
    end
    Spree::ProductDistribution.create(distribution_attrs)
  end

  def self.assign_license_to(user)
    Spree::LicensedProduct.where(email: user.email).find_each do |licensed_product|
      licensed_product.update(user: user)
    end
  end

  private

  def set_expire_at
    if self.product.license_length.present? && self.expire_at.blank?
      self.expire_at = product.license_length.days.since(Time.now)
    end
  end

  def set_user
    if self.user.blank? && self.email.present?
      self.user_id = Spree::User.find_by(email: self.email).try(:id)
    end
  end
end
