class AddAccessUrlToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :access_url, :string
  end
end
