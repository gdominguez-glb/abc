class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :blog_id
      t.integer :user_id
      t.integer :subscribe_status

      t.timestamps null: false
    end
  end
end
