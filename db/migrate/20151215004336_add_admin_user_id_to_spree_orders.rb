class AddAdminUserIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :admin_user_id, :integer
  end
end
