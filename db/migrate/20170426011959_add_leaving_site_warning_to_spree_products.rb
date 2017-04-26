class AddLeavingSiteWarningToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :leaving_site_warning, :boolean, default: true
  end
end
