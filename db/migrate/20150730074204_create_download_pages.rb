class CreateDownloadPages < ActiveRecord::Migration
  def change
    create_table :download_pages do |t|
      t.string :title
      t.text :description
      t.string :slug

      t.timestamps null: false
    end
  end
end
