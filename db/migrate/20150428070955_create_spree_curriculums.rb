class CreateSpreeCurriculums < ActiveRecord::Migration
  def change
    create_table :spree_curriculums do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
