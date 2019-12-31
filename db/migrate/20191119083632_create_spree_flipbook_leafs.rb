class CreateSpreeFlipbookLeafs < ActiveRecord::Migration
  def change
    create_table :spree_flipbook_leafs do |t|
      t.string :name
      t.integer :product_id
      t.integer :position

      t.timestamps null: false
    end
  end
end
