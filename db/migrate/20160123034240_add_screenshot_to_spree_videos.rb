class AddScreenshotToSpreeVideos < ActiveRecord::Migration
  def up
    add_attachment :spree_videos, :screenshot
  end

  def down
    remove_attachment :spree_videos, :screenshot
  end
end
