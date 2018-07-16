class AddInklingIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :inkling_id, :string
  end
end
