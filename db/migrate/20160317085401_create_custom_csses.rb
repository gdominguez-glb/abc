class CreateCustomCsses < ActiveRecord::Migration
  def change
    create_table :custom_csses do |t|
      t.string :name
      t.integer :page_id
      t.integer :custom_type
      t.text :content

      t.timestamps null: false
    end
  end
end
