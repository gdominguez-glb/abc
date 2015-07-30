class CreateDownloadProducts < ActiveRecord::Migration
  def change
    create_table :download_products do |t|
      t.integer :download_page_id
      t.integer :product_id
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
