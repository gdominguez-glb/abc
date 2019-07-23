class AddProductToDomain < ActiveRecord::Migration
  def change
    add_reference :domains, :spree_product, index: true
    add_foreign_key :domains, :spree_products
  end
end
