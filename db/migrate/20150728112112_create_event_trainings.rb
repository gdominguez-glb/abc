class CreateEventTrainings < ActiveRecord::Migration
  def change
    create_table :event_trainings do |t|
      t.string :title
      t.text :content
      t.string :training_type

      t.timestamps null: false
    end
  end
end
