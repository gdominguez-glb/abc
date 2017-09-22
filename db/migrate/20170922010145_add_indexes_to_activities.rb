class AddIndexesToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :updated_at
    add_index :activities, :user_id
    add_index :activities, :item_id
    add_index :activities, :item_type
    add_index :activities, :action
  end
end
