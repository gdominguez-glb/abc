class AddInternalNameToSpreeProducts < ActiveRecord::Migration
  def up
    add_column :spree_products, :internal_name, :string
    Spree::Product.find_each do |product|
      product.internal_name = product.name
      product.save(validate: false)
    end
  end

  def down
    remove_column :spree_products, :internal_name
  end
end
