class AddVideoGroupIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :video_group_id, :integer
  end
end
