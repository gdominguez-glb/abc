class AddForSaleToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :for_sale, :boolean, default: false
  end
end
