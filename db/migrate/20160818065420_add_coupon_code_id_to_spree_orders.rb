class AddCouponCodeIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :coupon_code_id, :integer
  end
end
