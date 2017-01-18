class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :name
      t.text :description
      t.string :field_type
      t.string :salesforce_field_name
      t.string :subject
      t.string :user_title
      t.boolean :display, default: false
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
