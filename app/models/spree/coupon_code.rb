class Spree::CouponCode < ActiveRecord::Base
  belongs_to :school_district

  has_many :coupon_code_products, class_name: 'Spree::CouponCodeProduct'
  has_many :products, class_name: 'Spree::Product', through: :coupon_code_products
end
