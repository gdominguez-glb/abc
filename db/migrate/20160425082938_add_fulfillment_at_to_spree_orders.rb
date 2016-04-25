class AddFulfillmentAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :fulfillment_at, :date
  end
end
