class AddIndexesToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_index :spree_licensed_products, :user_id
    add_index :spree_licensed_products, :product_id
    add_index :spree_licensed_products, :can_be_distributed
    add_index :spree_licensed_products, :expire_at
    add_index :spree_licensed_products, :fulfillment_at
    add_index :spree_licensed_products, :quantity
  end
end
