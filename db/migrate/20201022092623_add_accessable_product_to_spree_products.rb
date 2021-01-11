class AddAccessableProductToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :has_eureka_access, :boolean, default: false
  end
end
