class CreateDownloadJobs < ActiveRecord::Migration
  def change
    create_table :download_jobs do |t|
      t.integer :user_id
      t.text :material_ids
      t.string :status
      t.integer :percent

      t.timestamps null: false
    end
  end
end
