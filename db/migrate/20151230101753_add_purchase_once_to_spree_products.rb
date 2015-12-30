class AddPurchaseOnceToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :purchase_once, :boolean, default: false
  end
end
