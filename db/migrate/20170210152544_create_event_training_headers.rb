class CreateEventTrainingHeaders < ActiveRecord::Migration
  def change
    create_table :event_training_headers do |t|
      t.string :name
      t.integer :position, default: 0
      t.references :training_type_category, index: true

      t.timestamps null: false
    end
  end
end
