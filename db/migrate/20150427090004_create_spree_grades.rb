class CreateSpreeGrades < ActiveRecord::Migration
  def change
    create_table :spree_grades do |t|
      t.string :name
      t.string :abbr
      t.string :school
      t.integer :position,          default: 0

      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
