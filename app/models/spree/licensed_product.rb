class Spree::LicensedProduct < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :order, class_name: 'Spree::Order'
  belongs_to :user, class_name: 'Spree::User'

  scope :available, -> { where("expire_at > ?", Time.now) }

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
end
