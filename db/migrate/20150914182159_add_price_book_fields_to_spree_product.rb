class AddPriceBookFieldsToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :sf_id_product, :string
    add_column :spree_products, :sf_id_pricebook, :string
  end
end
