class CreateSpreeVideos < ActiveRecord::Migration
  def change
    create_table :spree_videos do |t|
      t.string :title
      t.text :description
      t.integer :product_id
      t.boolean :is_free

      t.timestamps null: false
    end
  end
end
