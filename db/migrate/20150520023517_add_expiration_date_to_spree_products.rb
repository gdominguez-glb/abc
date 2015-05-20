class AddExpirationDateToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :expiration_date, :datetime
    add_index :spree_products, :expiration_date
  end
end
