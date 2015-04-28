class CreateSpreeGradeUnits < ActiveRecord::Migration
  def change
    create_table :spree_grade_units do |t|
      t.integer :grade_id
      t.string :name
      t.integer :position, default: 0

      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
