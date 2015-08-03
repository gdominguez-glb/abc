class AddFileToDownloadJobs < ActiveRecord::Migration
  def up
    add_attachment :download_jobs, :file
  end

  def down
    remove_attachment :download_jobs, :file
  end
end
