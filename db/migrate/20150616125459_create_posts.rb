class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :medium_publication_id
      t.string :title
      t.string :subtitle
      t.datetime :published_at
      t.string :medium_id
      t.text :body

      t.timestamps null: false
    end
  end
end
