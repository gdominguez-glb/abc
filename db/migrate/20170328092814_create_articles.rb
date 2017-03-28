class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :blog_id
      t.string :title
      t.text :body
      t.text :body_draft
      t.integer :publish_status, default: 0
      t.integer :draft_status, default: 0
      t.datetime :archived_at
      t.boolean :archived, default: false
      t.boolean :display, default: false
      t.string :slug

      t.timestamps null: false
    end
  end
end
