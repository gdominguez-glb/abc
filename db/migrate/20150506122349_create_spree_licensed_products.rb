class CreateSpreeLicensedProducts < ActiveRecord::Migration
  def change
    create_table :spree_licensed_products do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :order_id
      t.datetime :expire_at

      t.timestamps null: false
    end
  end
end
