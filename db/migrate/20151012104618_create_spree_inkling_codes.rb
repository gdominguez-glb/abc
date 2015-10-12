class CreateSpreeInklingCodes < ActiveRecord::Migration
  def change
    create_table :spree_inkling_codes do |t|
      t.integer :product_id
      t.text :code

      t.timestamps null: false
    end
  end
end
