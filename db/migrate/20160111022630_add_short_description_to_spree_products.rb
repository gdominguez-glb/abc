class AddShortDescriptionToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :short_description, :text
  end
end
