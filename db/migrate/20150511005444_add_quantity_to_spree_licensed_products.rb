class AddQuantityToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :quantity, :integer, default: 0
  end
end
