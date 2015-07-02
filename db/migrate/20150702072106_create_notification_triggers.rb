class CreateNotificationTriggers < ActiveRecord::Migration
  def change
    create_table :notification_triggers do |t|
      t.string :target_type
      t.string :user_type
      t.text :user_ids
      t.integer :school_district_admin_user_id
      t.text :content

      t.timestamps null: false
    end
  end
end
