class AddAdminUserIdToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :admin_user_id, :integer
  end
end
