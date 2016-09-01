class AddTimestampToSpreeCouponCodesProducts < ActiveRecord::Migration
  def change
    add_timestamps(:spree_coupon_codes_products, null: true)
  end
end
