class CreateLinkFiles < ActiveRecord::Migration
  def change
    create_table :link_files do |t|
      t.string :slug

      t.timestamps null: false
    end
  end
end
