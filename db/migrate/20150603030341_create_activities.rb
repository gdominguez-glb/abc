class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.string :title
      t.integer :item_id
      t.string :item_type
      t.string :action

      t.timestamps null: false
    end
  end
end
