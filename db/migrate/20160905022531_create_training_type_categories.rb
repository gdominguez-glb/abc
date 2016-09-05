class CreateTrainingTypeCategories < ActiveRecord::Migration
  def change
    create_table :training_type_categories do |t|
      t.string :title
      t.text :description
      t.boolean :is_default, default: false
      t.string :slug

      t.timestamps null: false
    end
  end
end
