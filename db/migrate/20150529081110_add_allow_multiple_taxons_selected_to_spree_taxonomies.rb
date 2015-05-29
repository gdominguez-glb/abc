class AddAllowMultipleTaxonsSelectedToSpreeTaxonomies < ActiveRecord::Migration
  def change
    add_column :spree_taxonomies, :allow_multiple_taxons_selected, :boolean, default: true
  end
end
