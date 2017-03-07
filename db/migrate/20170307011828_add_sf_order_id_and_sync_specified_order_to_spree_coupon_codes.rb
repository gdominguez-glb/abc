class AddSfOrderIdAndSyncSpecifiedOrderToSpreeCouponCodes < ActiveRecord::Migration
  def change
    add_column :spree_coupon_codes, :sf_order_id, :string
    add_column :spree_coupon_codes, :sync_specified_order, :boolean
  end
end
