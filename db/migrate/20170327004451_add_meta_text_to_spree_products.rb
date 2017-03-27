class AddMetaTextToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :meta_text, :text
    add_index :spree_products, :meta_text
  end
end
