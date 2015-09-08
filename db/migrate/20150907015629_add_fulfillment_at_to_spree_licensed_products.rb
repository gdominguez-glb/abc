class AddFulfillmentAtToSpreeLicensedProducts < ActiveRecord::Migration
  def change
    add_column :spree_licensed_products, :fulfillment_at, :datetime
  end
end
