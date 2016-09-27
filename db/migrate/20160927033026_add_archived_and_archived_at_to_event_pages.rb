class AddArchivedAndArchivedAtToEventPages < ActiveRecord::Migration
  def change
    add_column :event_pages, :archived, :boolean, default: false
    add_column :event_pages, :archived_at, :datetime
  end
end
