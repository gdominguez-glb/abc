class ChangeFileSizeTypeInVideos < ActiveRecord::Migration
  def up
    change_column :spree_videos, :file_file_size, :bigint
  end

  def down
    change_column :spree_videos, :file_file_size, :bigint
  end
end
