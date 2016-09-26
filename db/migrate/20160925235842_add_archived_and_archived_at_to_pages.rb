class AddArchivedAndArchivedAtToPages < ActiveRecord::Migration
  def change
    add_column :pages, :archived, :boolean, default: false
    add_column :pages, :archived_at, :datetime
  end
end
