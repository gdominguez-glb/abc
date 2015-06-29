class AddProductDistributionIdToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :product_distribution_id, :integer
  end
end
