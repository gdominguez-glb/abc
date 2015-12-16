class AddSfContactIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :sf_contact_id, :string
  end
end
