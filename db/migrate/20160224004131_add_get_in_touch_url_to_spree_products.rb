class AddGetInTouchUrlToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :get_in_touch_url, :string
  end
end
