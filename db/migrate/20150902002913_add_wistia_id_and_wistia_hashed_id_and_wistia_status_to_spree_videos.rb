class AddWistiaIdAndWistiaHashedIdAndWistiaStatusToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :wistia_id, :integer
    add_column :spree_videos, :wistia_hashed_id, :string
    add_column :spree_videos, :wistia_status, :string
  end
end
