class AddFulfillmentDateToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :fulfillment_date, :datetime
  end
end
