class ChangeVideoIsFreeDefault < ActiveRecord::Migration
  def up
    change_column :spree_videos, :is_free, :boolean, default: false
  end

  def down
    change_column :spree_videos, :is_free, :boolean, default: false
  end
end
