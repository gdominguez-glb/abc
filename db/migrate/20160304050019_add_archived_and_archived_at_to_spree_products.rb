class AddArchivedAndArchivedAtToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :archived, :boolean, default: false
    add_column :spree_products, :archived_at, :datetime
  end
end
