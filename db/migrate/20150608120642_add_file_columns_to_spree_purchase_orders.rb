class AddFileColumnsToSpreePurchaseOrders < ActiveRecord::Migration
  def up
    add_attachment :spree_purchase_orders, :file
  end

  def down
    remove_attachment :spree_purchase_orders, :file
  end
end
