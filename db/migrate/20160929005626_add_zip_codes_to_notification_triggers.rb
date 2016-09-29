class AddZipCodesToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :zip_codes, :text
  end
end
