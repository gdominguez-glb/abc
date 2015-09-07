class RemoveFavoriteProducts < ActiveRecord::Migration
  def up
    drop_table :spree_favorite_products
  end

  def down
    create_table :spree_favorite_products do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
