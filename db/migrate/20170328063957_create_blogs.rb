class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.integer :blog_type
      t.integer :position
      t.boolean :display
      t.string :slug
      t.string :header
      t.text :description
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
