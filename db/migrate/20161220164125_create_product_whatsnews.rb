class CreateProductWhatsnews < ActiveRecord::Migration
  def change
    create_table :products_what_news do |t|
      t.integer :product_id
      t.integer :what_new_id
    end
  end
end
