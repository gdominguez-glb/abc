class AddLicenseAdminEmailToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :license_admin_email, :string
  end
end
