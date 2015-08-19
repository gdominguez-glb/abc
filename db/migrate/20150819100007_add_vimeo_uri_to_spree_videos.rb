class AddVimeoUriToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :vimeo_uri, :string
  end
end
