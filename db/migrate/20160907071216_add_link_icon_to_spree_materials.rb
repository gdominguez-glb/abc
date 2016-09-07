class AddLinkIconToSpreeMaterials < ActiveRecord::Migration
  def change
    add_column :spree_materials, :link_icon, :string, default: 'open_in_browser'
  end
end
