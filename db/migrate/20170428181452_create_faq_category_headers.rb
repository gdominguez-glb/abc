class CreateFaqCategoryHeaders < ActiveRecord::Migration
  def change
    create_table :faq_category_headers do |t|
      t.string :name
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
