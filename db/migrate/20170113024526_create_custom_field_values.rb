class CreateCustomFieldValues < ActiveRecord::Migration
  def change
    create_table :custom_field_values do |t|
      t.integer :user_id
      t.integer :custom_field_id
      t.text :value

      t.timestamps null: false
    end
  end
end
