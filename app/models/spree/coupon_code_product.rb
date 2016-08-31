class Spree::CouponCodeProduct < ActiveRecord::Base
  self.table_name = "spree_coupon_codes_products"
  
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :coupon_code, class_name: 'Spree::CouponCode'
end
