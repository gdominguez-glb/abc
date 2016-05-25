class AddModuleOrderAndLessonOrderToSpreeVideos < ActiveRecord::Migration
  def change
    add_column :spree_videos, :module_order, :integer
    add_column :spree_videos, :lesson_order, :integer
  end
end
