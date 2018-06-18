class CreateSpreePinnedProducts < ActiveRecord::Migration
  def change
    create_table :spree_pinned_products do |t|
      t.integer :product_id, index: true
      t.integer :user_id, index: true

      t.timestamps null: false
    end
  end
end
