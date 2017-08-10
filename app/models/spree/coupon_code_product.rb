class Spree::CouponCodeProduct < ActiveRecord::Base
  self.table_name = "spree_coupon_codes_products"
  
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :coupon_code, class_name: 'Spree::CouponCode'

  scope :available, -> { where('used_quantity < quantity') }

  def increase_used_quantity!
    self.update_column(:used_quantity, self.used_quantity + 1)
    self.coupon_code.update_column(:used_quantity, (self.coupon_code.used_quantity || 0) + 1)
  end

end
