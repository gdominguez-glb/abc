class CreateProductWhatsnews < ActiveRecord::Migration
  def change
    create_table :products_whats_news do |t|
      t.integer :product_id
      t.integer :whats_new_id
    end
  end
end
