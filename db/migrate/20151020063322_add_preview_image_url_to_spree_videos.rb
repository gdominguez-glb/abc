class AddPreviewImageUrlToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :preview_image_url, :string
  end
end
