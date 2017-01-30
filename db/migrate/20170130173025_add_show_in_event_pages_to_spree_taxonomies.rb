class AddShowInEventPagesToSpreeTaxonomies < ActiveRecord::Migration
  def change
    add_column :spree_taxonomies, :show_in_event_pages, :boolean, default: false
  end
end
