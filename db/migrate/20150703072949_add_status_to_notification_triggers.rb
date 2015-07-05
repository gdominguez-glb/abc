class AddStatusToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :status, :string, default: 'pending'
  end
end
