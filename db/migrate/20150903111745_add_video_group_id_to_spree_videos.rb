class AddVideoGroupIdToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :video_group_id, :integer
  end
end
