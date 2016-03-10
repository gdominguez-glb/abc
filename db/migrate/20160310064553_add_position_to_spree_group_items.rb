class AddPositionToSpreeGroupItems < ActiveRecord::Migration
  def change
    add_column :spree_group_items, :position, :integer
  end
end
