class AddEnableSingleDistributionToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :enable_single_distribution, :boolean, default: false
  end
end
