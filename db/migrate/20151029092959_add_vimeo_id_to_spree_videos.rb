class AddVimeoIdToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :vimeo_id, :string
  end
end
