class AddArchivedAndArchivedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :archived, :boolean, default: false
    add_column :questions, :archived_at, :datetime
  end
end
