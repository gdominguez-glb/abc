class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.integer :position
      t.boolean :display, default: false

      t.timestamps null: false
    end
  end
end
