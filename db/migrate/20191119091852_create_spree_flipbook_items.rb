class CreateSpreeFlipbookItems < ActiveRecord::Migration
  def change
    create_table :spree_flipbook_items do |t|
      t.integer :flipbook_leaf_id
      t.string :name
      t.integer :position
      t.text :inkling_code
      t.integer :item_type

      t.timestamps null: false
    end
    add_attachment :spree_flipbook_items, :cover
    add_attachment :spree_flipbook_items, :attachment
  end

  def down
    remove_attachment :spree_flipbook_items, :attachment
    remove_attachment :spree_flipbook_items, :cover

    drop_table :spree_flipbook_items
  end
end
