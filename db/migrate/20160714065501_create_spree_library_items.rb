class CreateSpreeLibraryItems < ActiveRecord::Migration
  def up
    create_table :spree_library_items do |t|
      t.integer :library_leaf_id
      t.string :name
      t.integer :position
      t.text :inkling_code
      t.string :item_type

      t.timestamps null: false
    end

    add_attachment :spree_library_items, :cover
    add_attachment :spree_library_items, :attachment
  end

  def down
    remove_attachment :spree_library_items, :attachment
    remove_attachment :spree_library_items, :cover

    drop_table :spree_library_items
  end
end
