class AddExpireAtToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :expire_at, :datetime
  end
end
