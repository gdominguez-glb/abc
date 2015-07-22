class AddPositionToSpreeMaterials < ActiveRecord::Migration
  def change
    add_column :spree_materials, :position, :integer, default: 0
  end
end
