class AddMaterialFilesCountToSpreeMaterials < ActiveRecord::Migration
  def up
    add_column :spree_materials, :material_files_count, :integer, default: 0
    Spree::Material.reset_column_information
    Spree::Material.find_each do |m|
      Spree::Material.update_counters m.id, material_files_count: m.material_files.length
    end
  end

  def down
    remove_column :spree_materials, :material_files_count
  end
end
