class Spree::CouponCodeProduct < ActiveRecord::Base
  belongs_to :coupon_code, class_name: 'Spree::CouponCode'
  belongs_to :product, class_name: 'Spree::Product'
end
