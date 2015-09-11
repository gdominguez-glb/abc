class AddShowInStoreAndShowInVideoToSpreeTaxonomies < ActiveRecord::Migration
  def change
    add_column :spree_taxonomies, :show_in_store, :boolean, default: true
    add_column :spree_taxonomies, :show_in_video, :boolean, default: true
  end
end
