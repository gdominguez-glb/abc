class CreateCustomFieldOptions < ActiveRecord::Migration
  def change
    create_table :custom_field_options do |t|
      t.integer :custom_field_id
      t.string :value
      t.string :label

      t.timestamps null: false
    end
  end
end
