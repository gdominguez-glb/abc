class AddCustomOrderToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :custom_order, :integer
  end
end
