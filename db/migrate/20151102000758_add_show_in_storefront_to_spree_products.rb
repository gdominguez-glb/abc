class AddShowInStorefrontToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :show_in_storefront, :boolean, default: true
  end
end
