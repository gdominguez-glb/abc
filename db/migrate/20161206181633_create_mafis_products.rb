class CreateMafisProducts < ActiveRecord::Migration
  def change
    create_table :mafis_products do |t|
      t.string :record_id
      t.string :name
      t.string :image
      t.text :small_description
      t.text :description
      t.decimal :price
      t.integer :grade
      t.string :isbn

      t.timestamps null: false
    end
  end
end
