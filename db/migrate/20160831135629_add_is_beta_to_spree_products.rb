class AddIsBetaToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_beta, :boolean, default: false
  end
end
