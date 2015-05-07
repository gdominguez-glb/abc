class CreateContactTopics < ActiveRecord::Migration
  def change
    create_table :contact_topics do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
