class AddSourceToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :source, :integer, default: 0
  end
end
