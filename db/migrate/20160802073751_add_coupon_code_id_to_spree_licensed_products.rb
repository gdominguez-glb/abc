class AddCouponCodeIdToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :coupon_code_id, :integer
  end
end
