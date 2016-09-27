class AddArchivedAndArchivedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :archived, :boolean, default: false
    add_column :jobs, :archived_at, :datetime
  end
end
