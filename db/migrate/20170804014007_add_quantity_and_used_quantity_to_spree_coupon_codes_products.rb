class AddQuantityAndUsedQuantityToSpreeCouponCodesProducts < ActiveRecord::Migration
  def change
    add_column :spree_coupon_codes_products, :quantity, :integer, default: 0
    add_column :spree_coupon_codes_products, :used_quantity, :integer, default: 0
  end
end
