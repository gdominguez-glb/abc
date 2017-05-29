class CreateSubscriptionNotifications < ActiveRecord::Migration
  def change
    create_table :subscription_notifications do |t|
      t.integer :subscription_id
      t.integer :article_id

      t.timestamps null: false
    end
  end
end
