class AddProductIdToNotificationTriggers < ActiveRecord::Migration
  def change
    add_column :notification_triggers, :product_id, :integer
  end
end
