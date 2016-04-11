class AddPositionToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :position, :integer
  end
end
