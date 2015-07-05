class AddSingleUserIdAndNotifyAtToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :single_user_id, :integer
    add_column :notification_triggers, :notify_at, :datetime
  end
end
