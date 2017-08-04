class AddPrimaryKeyToSpreeCouponCodesProducts < ActiveRecord::Migration
  def change
    add_column :spree_coupon_codes_products, :id, :primary_key
  end

end
