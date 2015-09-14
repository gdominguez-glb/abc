class CreateFaqCategories < ActiveRecord::Migration
  def change
    create_table :faq_categories do |t|
      t.string :name
      t.integer :position
      t.boolean :display, default: false

      t.timestamps null: false
    end
  end
end
