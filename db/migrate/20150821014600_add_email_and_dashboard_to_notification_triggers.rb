class AddEmailAndDashboardToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :email, :boolean, default: false
    add_column :notification_triggers, :dashboard, :boolean, default: false
  end
end
