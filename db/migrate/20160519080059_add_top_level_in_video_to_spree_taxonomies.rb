class AddTopLevelInVideoToSpreeTaxonomies < ActiveRecord::Migration
  def change
    add_column :spree_taxonomies, :top_level_in_video, :boolean, default: false
  end
end
