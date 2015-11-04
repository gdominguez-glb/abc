class CreateCurriculumShops < ActiveRecord::Migration
  def change
    create_table :curriculum_shops do |t|
      t.string :title
      t.string :url
      t.integer :page_id

      t.timestamps null: false
    end
  end
end
