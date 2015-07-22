class AddExpireAtToSpreeProductDistributions < ActiveRecord::Migration
  def change
    add_column :spree_product_distributions, :expire_at, :datetime
  end
end
