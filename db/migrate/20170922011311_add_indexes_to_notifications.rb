class AddIndexesToNotifications < ActiveRecord::Migration
  def change
    add_index :notifications, :user_id
    add_index :notifications, :read
    add_index :notifications, :expire_at
    add_index :notifications, :created_at
  end
end
