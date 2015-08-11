class CreateProductTracks < ActiveRecord::Migration
  def change
    create_table :product_tracks do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :material_id

      t.timestamps null: false
    end
  end
end
