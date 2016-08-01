class CreateSpreeCouponCodesAndProducts < ActiveRecord::Migration
  def change
    create_join_table(:coupon_codes, :products, table_name: :spree_coupon_codes_products)
  end
end
