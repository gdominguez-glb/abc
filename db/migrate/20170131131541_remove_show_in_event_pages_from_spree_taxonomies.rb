class RemoveShowInEventPagesFromSpreeTaxonomies < ActiveRecord::Migration
  def change
    remove_column :spree_taxonomies, :show_in_event_pages
  end
end
