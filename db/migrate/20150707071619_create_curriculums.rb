class CreateCurriculums < ActiveRecord::Migration
  def change
    create_table :curriculums do |t|
      t.string :name
      t.integer :position, default: 0
      t.boolean :display, default: false

      t.timestamps null: false
    end
  end
end
