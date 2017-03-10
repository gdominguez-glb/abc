class AddProductIdsToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :product_ids, :text
  end
end
