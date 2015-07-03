class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :notification_trigger_id
      t.text :content
      t.boolean :read, default: false

      t.timestamps null: false
    end
  end
end
