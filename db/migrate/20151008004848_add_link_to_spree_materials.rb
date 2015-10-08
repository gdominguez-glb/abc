class AddLinkToSpreeMaterials < ActiveRecord::Migration
  def change
    add_column :spree_materials, :link, :string
  end
end
