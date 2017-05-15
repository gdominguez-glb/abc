class AddFieldsToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :sign_up_started_at, :date
    add_column :notification_triggers, :sign_up_ended_at, :date
  end
end
