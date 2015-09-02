class AddWistiaThumbnailUrlToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :wistia_thumbnail_url, :string
  end
end
