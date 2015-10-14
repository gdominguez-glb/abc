class CreateSpreeProductAgreements < ActiveRecord::Migration
  def change
    create_table :spree_product_agreements do |t|
      t.integer :product_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
