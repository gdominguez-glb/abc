class CreateSpreeMaterials < ActiveRecord::Migration
  def change
    create_table :spree_materials do |t|
      t.string :name
      t.integer :product_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, default: 0
      t.integer :children_count, default: 0

      t.timestamps null: false
    end
  end
end
