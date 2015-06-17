class CreateMediumPublications < ActiveRecord::Migration
  def change
    create_table :medium_publications do |t|
      t.string :title
      t.string :url
      t.string :blog_type
      t.string :curriculum
      t.integer :position
      t.boolean :display

      t.timestamps null: false
    end
  end
end
