class AddExpireAtToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :expire_at, :datetime
  end
end
