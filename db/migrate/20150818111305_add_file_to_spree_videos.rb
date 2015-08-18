class AddFileToSpreeVideos < ActiveRecord::Migration
  def up
    add_attachment :spree_videos, :file
  end

  def down
    remove_attachment :spree_videos, :file
  end
end
