class AddGradeOrderToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :grade_order, :integer
  end
end
