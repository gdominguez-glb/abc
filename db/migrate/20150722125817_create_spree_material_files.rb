class CreateSpreeMaterialFiles < ActiveRecord::Migration
  def up
    create_table :spree_material_files do |t|
      t.integer :material_id
      t.timestamps null: false
    end

    add_attachment :spree_material_files, :file
  end

  def down
    remove_attachment :spree_material_files, :file
    drop_table :spree_material_files
  end
end
