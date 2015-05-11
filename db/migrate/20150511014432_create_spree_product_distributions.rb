class CreateSpreeProductDistributions < ActiveRecord::Migration
  def change
    create_table :spree_product_distributions do |t|
      t.integer :licensed_product_id
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :quantity
      t.string :email
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
